require "./spec_helper"

ERROR_MESSAGES.each do |error|
  it "#{error} has a message file" do
    File.exists?("./src/messages/#{error}.cr").should eq(true)
  end
end

Dir.glob("./src/messages/**/*").each do |file|
  basename = File.basename(file)[0..-4]

  it "#{basename} has an associated error" do
    ERROR_MESSAGES.includes?(basename).should eq(true)
  end
end

Dir
  .glob("./spec/messages/**/*")
  .select! { |file| File.file?(file) }
  .sort!
  .each do |file|
    it file do
      sample, expected = File.read(file).split("-" * 80)

      begin
        ast = Mint::Parser.parse(sample, file)

        type_checker = Mint::TypeChecker.new(ast)
        type_checker.check

        fail "Should raise Mint::Error"
      rescue error : Mint::Error
        message = error.to_terminal.to_s.uncolorize
        begin
          message.should eq(expected.strip)
        rescue
          fail diff(expected, message)
        end
      end
    end
  end
