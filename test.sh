#!/bin/bash

# CowGreeting Local Test Script
# This script builds and tests the .deb package locally

set -e

echo "🐄 CowGreeting Local Test Script"
echo "================================"

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   echo "❌ Please don't run this script as root"
   exit 1
fi

# Function to cleanup on exit
cleanup() {
    echo "🧹 Cleaning up..."
    if dpkg -l | grep -q cowgreeting; then
        echo "Removing installed package..."
        sudo dpkg -r cowgreeting || true
    fi
}
trap cleanup EXIT

echo "📦 Step 1: Installing build dependencies..."
sudo apt-get update -qq
sudo apt-get install -y build-essential debhelper devscripts cowsay lintian

echo "🔨 Step 2: Building Debian package..."
debuild -b -us -uc

echo "📋 Step 3: Verifying package contents..."
dpkg -c ../cowgreeting_*.deb

echo "📥 Step 4: Installing package..."
sudo dpkg -i ../cowgreeting_*.deb

echo "✅ Step 5: Testing basic functionality..."
echo "Testing cowgreeting command:"
cowgreeting

echo ""
echo "Testing greetcow command:"
greetcow

echo "🔧 Step 6: Testing plugin directory auto-creation..."
rm -rf ~/.config/cowgreeting
cowgreeting > /dev/null
ls -la ~/.config/cowgreeting/plugins/

echo "🧪 Step 7: Testing custom plugin..."
cat > ~/.config/cowgreeting/plugins/test-plugin.sh << 'EOF'
#!/bin/bash
echo "🧪 Local test plugin working!"
exit 0
EOF
chmod +x ~/.config/cowgreeting/plugins/test-plugin.sh

output=$(cowgreeting)
if echo "$output" | grep -q "🧪 Local test plugin working!"; then
    echo "✅ Custom plugin test passed!"
else
    echo "❌ Custom plugin test failed!"
    exit 1
fi

echo "⚙️ Step 8: Testing custom configuration..."
cat > ~/.config/cowgreeting/greetcow.conf << 'EOF'
TIME_FORMAT_24HR=true
SHOW_DATE=true
GREETING_TEMPLATE="Test greeting for USER at DATESTR"
EOF

output=$(cowgreeting)
if echo "$output" | grep -q "Test greeting"; then
    echo "✅ Custom configuration test passed!"
else
    echo "❌ Custom configuration test failed!"
    exit 1
fi

echo "🚫 Step 9: Testing error handling..."
cat > ~/.config/cowgreeting/plugins/broken-plugin.sh << 'EOF'
#!/bin/bash
echo "This plugin will fail"
exit 1
EOF
chmod +x ~/.config/cowgreeting/plugins/broken-plugin.sh

output=$(cowgreeting)
if echo "$output" | grep -q "Plugin Error"; then
    echo "✅ Error handling test passed!"
else
    echo "❌ Error handling test failed!"
    exit 1
fi

echo "📊 Step 10: Package information..."
dpkg -s cowgreeting
file ../cowgreeting_*.deb
du -h ../cowgreeting_*.deb

echo ""
echo "🎉 All tests passed successfully!"
echo "✅ Package built: $(ls ../cowgreeting_*.deb)"
echo "✅ Installation working"
echo "✅ Plugin system working" 
echo "✅ Configuration system working"
echo "✅ Error handling working"
echo ""
echo "The package will be automatically removed when this script exits." 