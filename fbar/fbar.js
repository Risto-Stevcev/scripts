const { parseStringPromise } = await import('xml2js')
const fs = await import('node:fs/promises')
const path = '/home/risto/Documents/Documents/Tax Returns/2022/'
const files = [
  'STB_Statement_200002985374230_20220101_20221231.xml', // MKD
  'STB_Statement_200003831478846_20220101_20221231.xml' // USD
]

async function maxBalance(accountFile) {
  let {
    StatementRs: {
      AccountInfo: [accountInfo],
      ListOfTransactions: [{ Transaction: transactions }]
    }
  } = await fs.readFile(`${path}/${accountFile}`, 'utf8').then(parseStringPromise)

  let transaction = transactions.reduce(
    (acc, e) => (Math.max(acc.Balance, e.Balance) == acc.Balance ? acc : e),
    { Balance: 0 }
  )

  /*
  record_date	country	currency	country_currency_desc	exchange_rate
  2021-12-31	Rep. of N Macedonia	Dinar	54.23
  2022-03-31	Rep. of N Macedonia	Dinar	55.41
  */

  return {
    accountInfo,
    currency: accountInfo.Currency[0],
    maxBalance: Number(transaction.Balance),
    date: transaction.ProcessDate[0]
  }
}

let MKD = await maxBalance(files[0])
let USD = await maxBalance(files[1])

console.log({
  currency: MKD.currency,
  maxBalance: MKD.maxBalance / 54.23,
  date: MKD.date
})
/*
{
  currency: 'MKD',
  maxBalance: 5369.131477042228,
  date: '2022-02-15T13:18:00'
}
*/

console.log(USD)
/*
{ currency: 'USD', maxBalance: 29606.97, date: '2022-03-15T09:57:00' }
*/
