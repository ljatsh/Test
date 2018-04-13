
var util = require('./util');
var Config = require('@tars/utils').Config;
var Endpoint = require('@tars/utils').Endpoint;
var timeProvider = require('@tars/utils').timeProvider;
var Promise = require('@tars/utils').Promise;
var assert = require('assert');

var text = util.text(function() {
/*
<tars>
    <application>
        enableset=n
        setdivision=NULL
        <server>
            node=tars.tarsnode.ServerObj@tcp -h 10.209.15.37 -p 19386 -t 60000
            app=TARS
            server=NodeTarsServer
            localip=10.209.15.37
            netthread=2
            local=tcp -h 127.0.0.1 -p 10002 -t 3000
            basepath=/usr/local/app/tars/tarsnode/data/TARS.NodetarsServer/bin/
            datapath=/usr/local/app/tars/tarsnode/data/TARS.NodeTarsServer/data/
            logpath=/usr/local/app/tars/app_log//
            logsize=15M
            config=tars.tarsconfig.ConfigObj
            notify=tars.tarsnotify.NotifyObj
            log=tars.tarslog.LogObj
            deactivating-timeout=3000
            openthreadcontext=0
            threadcontextnum=10000
            threadcontextstack=32768
            closeout=0
            <TARS.NodeTarsServer.NodeTarsObjAdapter>
                allow
                endpoint=tcp -h 127.0.0.1 -p 14002 -t 60000
                handlegroup=TARS.NodeTarsServer.NodeTarsObjAdapter
                maxconns=200000
                protocol=tars
                queuecap=10000
                queuetimeout=60000
                servant=TARS.NodeTarsServer.NodeTarsObj
                shmcap=0
                shmkey=0
                threads=5
            </TARS.NodeTarsServer.NodeTarsObjAdapter>
        </server>
        <client>
            locator=tars.tarsregistry.QueryObj@tcp -h 172.27.208.171 -p 17890:tcp -h 172.27.34.213 -p 17890
            refresh-endpoint-interval=60000
            stat=tars.tarsstat.StatObj
            property=tars.tarsproperty.PropertyObj
            report-interval=60000
            sample-rate=1000
            max-sample-count=100
            sendthread=1
            recvthread=1
            asyncthread=3
            modulename=TARS.NodeTarsServer
            async-invoke-timeout=60000
            sync-invoke-timeout=3000
        </client>
    </application>
</tars>

<HelloObj>
    Key = 1
    Value = 10
<HelloObj>
*/
});

describe('UtilTest', function() {
    it('ConfigTest', function() {
        var config = new Config();
        var result = config.parseText(text);
        assert.ok(result);

        assert.equal(config.get('tars.application.enableset'), 'n');
        assert.equal(config.get('tars.application.setdivision'), 'NULL');
        assert.equal(config.get('tars.application.server.app'), 'TARS');

        //// 可以存在多个根部domain
        assert.equal(config.get('HelloObj.Key'), '1');
        assert.equal(config.get('HelloObj.Value'), '10');

        var adapters = config.getDomain('tars.application.server');
        assert.equal(adapters.length, 1);
        assert.equal(adapters[0], 'TARS.NodeTarsServer.NodeTarsObjAdapter');

        adapters = config.getDomainValue('tars.application.server');
        assert.equal(adapters.length, 1);
        var adapter = adapters[0];
        assert.equal(adapter.endpoint, 'tcp -h 127.0.0.1 -p 14002 -t 60000');

        //// TODO
        //assert.equal(!config.parseText('<tars><a>a=1</b></tars>'), '貌似返回值有错误，暂不研究');
    });

    it('EndpointTest', function() {
        var endpoint = Endpoint.parse('tcp -h 127.0.0.1 -p 14002 -t 60000');
        assert.equal(endpoint.sProtocol, 'tcp');
        assert.equal(endpoint.sHost, '127.0.0.1');
        assert.equal(endpoint.iPort, 14002);
        assert.equal(endpoint.iTimeout, 60000);

        endpoint = Endpoint.parse('unix -h 127.0.0.1');
        assert.ok(endpoint === undefined);
    });
});
