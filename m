From: =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Subject: Re: cifs.ko + smb 3.0 + DFS fails (though direct mount succeeds)
Date: Tue, 20 Jun 2017 14:02:00 +0200
Message-ID: <mps4lvayiiv.fsf@aaptelpc.suse.de>
References: <CAJUwKM3-U2yRHB5O-R19wmzj1-yrO3sU_b8+xVCFaFwsZRWtTA@mail.gmail.com> <CAH2r5mvn_Z5B=kYza1gAr3SkPX+kwKmXBEXcTBL327zcW8FP-g@mail.gmail.com> <CAJUwKM25Kd-BHgPNXHkTtvYvK1Ad5uaLkooG6i4H+kawDL1ACg@mail.gmail.com> <mpsmv98ti7d.fsf@aaptelpc.suse.de> <CDE2E2CE-EE67-44AE-A0C8-D3AFF6EAAA01@cg-networks.de> <mpsa854xmxm.fsf@aaptelpc.suse.de> <58abb375-f7fb-58ec-4786-9ebd202fffa3@cg-networks.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Cc: Robin Blanchard <robin.blanchard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        "linux-cifs\@vger.kernel.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Christian Garling <christian.garling-JDaHaePr6SMW6PBduJaimg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <58abb375-f7fb-58ec-4786-9ebd202fffa3-JDaHaePr6SMW6PBduJaimg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I take it it doesn't work with your WS2016 either?

Could you open a new bug report on bugzilla.samba.org in the
cifsVFS/kernel fs section?

A network trace along with system log files with debugging enabled would
help a lot.

    echo 'module cifs +p' > /sys/kernel/debug/dynamic_debug/control
    echo 'file fs/cifs/* +p' > /sys/kernel/debug/dynamic_debug/control
    echo 1 > /proc/fs/cifs/cifsFYI
    echo 1 > /sys/module/dns_resolver/parameters/debug
     
    dmesg --clear
    tcpdump -w ws2016.pcap & pid=$!
    sleep 3
    mount.cifs ....
    sleep 3
    kill $pid
    dmesg > ws2016.log

this should generate a network capture in file ws2016.pcap and kernel
log messages in ws2016.log. Update the mount command with your
setup. Do it once against your WS2016 system, and once against your
WS2008 system.

-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Linux GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
