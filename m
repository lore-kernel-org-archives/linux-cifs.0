From: =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Subject: Re: cifs.ko + smb 3.0 + DFS fails (though direct mount succeeds)
Date: Mon, 19 Jun 2017 12:59:49 +0200
Message-ID: <mpsa854xmxm.fsf@aaptelpc.suse.de>
References: <CAJUwKM3-U2yRHB5O-R19wmzj1-yrO3sU_b8+xVCFaFwsZRWtTA@mail.gmail.com> <CAH2r5mvn_Z5B=kYza1gAr3SkPX+kwKmXBEXcTBL327zcW8FP-g@mail.gmail.com> <CAJUwKM25Kd-BHgPNXHkTtvYvK1Ad5uaLkooG6i4H+kawDL1ACg@mail.gmail.com> <mpsmv98ti7d.fsf@aaptelpc.suse.de> <CDE2E2CE-EE67-44AE-A0C8-D3AFF6EAAA01@cg-networks.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Cc: Robin Blanchard <robin.blanchard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        "linux-cifs\@vger.kernel.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Christian Garling <christian.garling-JDaHaePr6SMW6PBduJaimg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CDE2E2CE-EE67-44AE-A0C8-D3AFF6EAAA01-JDaHaePr6SMW6PBduJaimg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Christian Garling <christian.garling-JDaHaePr6SMW6PBduJaimg@public.gmane.org> writes:
> Wireshark sniffing on the Ubuntu system shows the request for the referral, also the response with the correct hostname of the fileserver holding the share. After that nothing happens and cifs-utils throws "Invalid argument". I dont know what argument should be wrong. I also tried cifs-utils 6.7 from the git repo with no luck.

I've just tested again kernel master against WS2016 with a link to a
WS2012 server and I can:

* mount to namespace and cd in the link
* mount the link
* mount a subdir under the link

and everything works properly with vers=2.0 vers=2.1 vers=3.0. With
vers=3.11 windows doesn't let me do the initial tree connect for some
reason.

mount -t cifs -vvv '//ws2016.suse.de/dfs3/link/sub' /mnt -o \
  'vers=3.0,domain=xyz,username=administrator,password=xyz'

Have you made sure your system can resolve both the main server hostname
and the target server (the hostname in the DFS query response)? Are you
using vers=xyz option when mounting?

-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Linux GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
