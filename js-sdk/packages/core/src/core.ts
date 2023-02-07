// @ts-ignore
import TronWeb from 'tronweb';

export interface ChainConfig {
    privateKey: string;
    fullHost: string;
}

export interface TrongridConfig {
    host: string;
    key: string;
}

export interface MainChainConfig {
    chain: ChainConfig;
    trongrid: TrongridConfig;
    feeLimit: number;
}

const tronWebValue: any = null;
export const tronObj = {
    tronWeb: tronWebValue,
};

export class Contract {
    private readonly _chain: ChainConfig;
    private readonly _trongrid: TrongridConfig;
    private readonly _feeLimit: number;
    private readonly _mainchain: any;

    constructor(config: MainChainConfig) {
        this._chain = config.chain;
        this._trongrid = config.trongrid;
        this._feeLimit = config.feeLimit;

        this._mainchain = new TronWeb(this._chain);

        if (this._trongrid && this._mainchain.setHeader && this._mainchain.fullNode.host === this._trongrid.host) {
            this._mainchain.setHeader({ 'TRON-PRO-API-KEY': this._trongrid.key });
        }
    }

    view = async (
        address: string,
        functionSelector: any,
        parameters: any[] = [],
        isDappTronWeb: boolean | undefined = true
    ): Promise<any> => {
        try {
            let tronWeb = this._mainchain;
            // @ts-ignore
            if (
                !isDappTronWeb &&
                tronObj.tronWeb &&
                tronObj.tronWeb.defaultAddress &&
                tronObj.tronWeb.defaultAddress.base58
            ) {
                tronWeb = tronObj.tronWeb;
            }
            const result = await tronWeb.transactionBuilder.triggerSmartContract(
                address,
                functionSelector,
                { _isConstant: true },
                parameters
            );
            return result && result.result ? result.constant_result : [];
        } catch (error: any) {
            console.log(`view error ${address} - ${functionSelector}`, error.message ? error.message : error);
            return [];
        }
    };

    triggerSmartContract = async (
        address: string,
        functionSelector: any,
        options: any = {},
        parameters: any[] = [],
        issuerAddress: string
    ) => {
        try {
            // const tronWeb = window.tronWeb;
            let tronWeb = tronObj.tronWeb;
            //if (!tronWeb) return;
            if (!tronWeb) {
                tronWeb = this._mainchain;
            }
            const transaction = await tronWeb.transactionBuilder.triggerSmartContract(
                address,
                functionSelector,
                Object.assign({ feeLimit: this._feeLimit }, options),
                parameters,
                issuerAddress
            );

            if (!transaction.result || !transaction.result.result) {
                throw new Error('Unknown trigger error: ' + JSON.stringify(transaction.transaction));
            }
            return transaction;
        } catch (error: any) {
            throw new Error(error);
        }
    };

    sign = async (transaction: any): Promise<any> => {
        try {
            const tronWeb = tronObj.tronWeb;
            if (!tronWeb) return;
            return await tronWeb.trx.sign(transaction.transaction);
        } catch (error: any) {
            console.log(error, 'sign error');
            throw new Error(error);
        }
    };

    sendRawTransaction = async (signedTransaction: any): Promise<any> => {
        try {
            let tronWeb = tronObj.tronWeb;
            if (!tronWeb) {
                tronWeb = this._mainchain;
            }
            return await tronWeb.trx.sendRawTransaction(signedTransaction);
        } catch (error:any) {
            throw new Error(error);
        }
    };
}
