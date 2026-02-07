if not Shared.CompatibilityTest then return end

function test_cash(source)
    TestHelper.TestMoney(source, "Cash", Core.GetCash, Core.AddCash, Core.RemoveCash)
end