trigger rateAutomationTrigger on Campaign (before insert, before update) {

    new rateAutomationTriggerHandler().run();
}