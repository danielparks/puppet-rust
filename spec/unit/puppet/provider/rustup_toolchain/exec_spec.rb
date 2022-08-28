# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Puppet::Type.type(:rustup_toolchain).provider(:exec) do
  it "should refuse to load instances" do
    expect { described_class.instances }
      .to raise_error(RuntimeError, /Cannot query rustup installations/)
  end

  let :resource do
    Puppet::Type.type(:rustup_toolchain).new(
      :title => "root: toolchain",
      :provider => :exec,
    )
  end

  let :provider do
    provider = described_class.new(resource)
    allow(provider).to receive(:load_default_triple) \
      .and_return("x86_64-apple-darwin")
    provider
  end

  it "has correct rustup_home" do
    expect(provider.rustup_home).to eq(File.expand_path("~root/.rustup"))
  end

  it "parses default toolchain correctly" do
    expect(provider.parse_default_triple)
      .to eq(["", "x86_64", "apple-darwin", nil])
  end

  context "produces good toolchain matchers" do
    it 'for "stable"' do
      expect(provider.make_toolchain_matcher("stable"))
        .to eq(/^stable-x86_64-apple-darwin(?: \(default\))?$/)
    end

    it 'for "custom-toolchain"' do
      expect(provider.make_toolchain_matcher("custom-toolchain"))
        .to eq(/^custom\-toolchain-x86_64-apple-darwin(?: \(default\))?$/)
    end

    it 'for "custom-toolchain-mscv"' do
      expect(provider.make_toolchain_matcher("custom-toolchain-msvc"))
        .to eq(/^custom\-toolchain-x86_64-apple-darwin-msvc(?: \(default\))?$/)
    end

    it 'for "custom-toolchain-pc-windows"' do
      expect(provider.make_toolchain_matcher("custom-toolchain-pc-windows"))
        .to eq(/^custom\-toolchain-x86_64-pc\-windows(?: \(default\))?$/)
    end
  end
end