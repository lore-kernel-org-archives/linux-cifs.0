From: =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Subject: RE: [PATCH v1 2/3] CIFS: make IPC a regular tcon
Date: Thu, 18 Jan 2018 11:30:04 +0100
Message-ID: <87607z4fyr.fsf@suse.com>
References: <20180117172200.3221-1-aaptel@suse.com> <20180117172200.3221-3-aaptel@suse.com> <DM5PR2101MB0936C7D8EE43D6E069870B10B6E80@DM5PR2101MB0936.namprd21.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Cc: "smfrench\@gmail.com" <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Pavel Shilovskiy <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        "linux-cifs\@vger.kernel.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <DM5PR2101MB0936C7D8EE43D6E069870B10B6E80-uvswG4RmAWieOSyIubIsYpz2gl+EIwcenBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Pavel Shilovskiy <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org> writes:
> Minor: it should probably work this way, but since we set ses->tcon_ipc under a spinlock in cifs_setup_ipc(), it would be better to do something similar here.

I was actually thinking that the spinlock might not be necessary for
that pointer. It's always only set at session creation (new tcon) and
destruction (to null). In between, it's only going to be read. What do
you think?

>> -       /*
>> -        * BB - map targetUNCs to dfs_info3 structures, here or in
>> -        * ses->server->ops->get_dfs_refer.
>> -        */
>
> Is this no longer needed?

If you are talking about the tcon creation, it is now done all the time
at session creation. If you are talking about that specific comment, I
believe it's already done now in parse_dfs_referrals(). That function
parses the packet into dfs_info3_param structures.

-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Linux GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
