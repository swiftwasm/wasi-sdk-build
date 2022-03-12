BUILD=build
WASI_SDK_DIR=wasi-sdk

$(BUILD)/.patched:
	[ -d $(BUILD) ] || mkdir -p $(BUILD)
	cat patches/wasi-sdk/*.patch | (cd $(WASI_SDK_DIR); patch -p1)
	cat patches/wasi-libc/*.patch | (cd $(WASI_SDK_DIR)/src/wasi-libc; patch -p1)
	touch $@
$(BUILD)/.wasi-sdk.BUILT: $(BUILD)/.patched
	make -C $(WASI_SDK_DIR) package
	touch $@

package: $(BUILD)/.wasi-sdk.BUILT
	rm -rf $(BUILD)/wasi-sysroot
	cp -R $(WASI_SDK_DIR)/build/install/opt/wasi-sdk/share/wasi-sysroot \
	  $(BUILD)/wasi-sysroot
	tar cfz wasi-sysroot.tar.gz -C $(BUILD) wasi-sysroot
