# encoding: utf-8

Bank.delete_all
[
  Bank.create!([{ name: '招商银行', url: 'http://www.cmbchina.com'}])
]
