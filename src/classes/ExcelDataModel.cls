public with sharing class ExcelDataModel {
    public list<SingleDataModel> data { get; set; }
    
    public class SingleDataModel {
        public string sheetname { get; set; }
        public list<string> headers { get; set; }
        public list<map<string,string>> data { get; set; }        
    }    
    
    
    public static testmethod void test1() {
        ExcelDataModel e = new ExcelDataModel();
        ExcelDataModel.SingleDataModel sdm = new ExcelDataModel.SingleDataModel();
    }
}