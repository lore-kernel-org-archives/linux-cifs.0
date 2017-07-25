From: =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Subject: Re: PROBLEM: CIFS SMB2/SMB3 does not work for domain based DFS
Date: Tue, 25 Jul 2017 19:08:32 +0200
Message-ID: <mpsmv7sculr.fsf@aaptelpc.suse.de>
References: <F303188D30C85B49969BE73949AA0F8C6F171F0DF0@EXCHANGE.totemo.net> <mpslgnl3hp8.fsf@aaptelpc.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
To: Totemo Support <support-4BUtOHJXg7LQT0dZR+AlfA@public.gmane.org>,
        "linux-cifs\@vger.kernel.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <mpslgnl3hp8.fsf-zpEvHKhluMwYitT5tn2FcQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Aurélien Aptel <aaptel-IBi9RG/b67k@public.gmane.org> writes:
> Could you open a bug report here [1] and provide network traces of you
> mounting with smb1 and another one of you mounting with smb3 (add them
> as attachement).

Bug was opened here [1].

In both traces cifs.ko connects to the DC and tries to connect to the
"files" share. Since the "files" share is not hosted on the DC, the
server replies with BAD_NETWORK_NAME error. It then connects to the IPC$
share regardless of the result (in get_dfs_path() I suspect).

SMB1 uses IPC$ to make the request whereas SMB2 does a ioctl on any
valid tcon object from the session. It finds none since the connection
to the share "files" failed.

I'm surprised it even works for SMB1 since you are saying the DFSN
server is not on the DC. In the SMB1 trace we can see cifs.ko connects
to the DC (10.0.9.56) and sends a DFS request to it (in #17) which the
DC sucessfully replies to (#18).

In order for the SMB2 code to be able to use the IPC$ share aswell we
need to make SMB2_ioctl() work when tcon is NULL and use_ipc is true
(probably by passing a session pointer as an extra arg). Looks like a
nasty refactoring is needed...

1: https://bugzilla.samba.org/show_bug.cgi?id=12917

-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Linux GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
