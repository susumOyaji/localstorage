
//import 'package:flutter/material.dart';
//import 'package:decimal/decimal.dart';


    class Finance
    {
        static List<Price> parse(var responce)
        {
            List<Price> prices = new List<Price>(); //ｺﾝｽﾄﾗｸﾀ
            var list = responce.split("\n"); 
              
              for( String row in list ) {
                if (row.isNotEmpty){
                    //continue;
                  var lista = row.split(",");  
                  //Price p = new Price(lista[0],lista[1],lista[2],lista[3],lista[4],lista[5],list[6]);
                  Price p = new Price();
                  p.code = lista[0];//企業コード
                  p.stocks = (lista[1]);//保有数
                  p.itemprice = (lista[2]);//購入単価
                  prices.add(p);

                  print('Finance=${list.indexOf(row)}: $row');
                }
              }                   
           return prices;
        }
    }

    class Price
    {
        String code ;//会社名コード
        String name;//会社名*
        var stocks;//保有数*
        dynamic itemprice;//購入価格*
        double realprice;//現在値**
        String prevday;//前日比±**
        String percent; //前日比％**
        String polar; //上げ下げ(+ or -)
        dynamic ayAssetprice;//保有数* 購入価格 = 投資総額
        dynamic realValue;//利益総額
       
        dynamic investmen;//投資額
        dynamic investmens;//投資総額
        dynamic uptoAsset;//個別利益
        dynamic totalAsset;//現在評価額合計
       
        double gain;//損益
        
        int idindex;

       
         //Price(this.code, this.stocks, this.itemprice,this.name,this.realValue,this.prev_day,this.percent );
    }


