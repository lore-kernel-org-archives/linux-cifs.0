From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: Don't replace dentries for dfs mounts
Date: Tue, 7 Apr 2015 09:04:45 -0500
Message-ID: <CAH2r5mtrFTP1RT-B-Ve5o2DsAj3yj-Pi6aryEuJ3TYQCukGNFg@mail.gmail.com>
References: <1427982695-29891-1-git-send-email-sprabhu@redhat.com>
 <20150403081406.1f8323d1@tlielax.poochiereds.net> <CAH2r5mt1JHCsnmTQmOgT5gSozig=UAreT=zqjuqDMsLtciqVJw@mail.gmail.com>
 <1428405981.32744.6.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Jeff Layton <jeff.layton-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1428405981.32744.6.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Apr 7, 2015 at 6:26 AM, Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Fri, 2015-04-03 at 20:57 -0500, Steve French wrote:
>> Looks reasonable but fails on SMB3 - we need to fix lines 133 and 134
>> of smb2pdu.c as well
>
> Hello Steve,
>
> I am not sure I understand how these lines are involved.
> The patch fixes behaviour for readdir where the lookup data doesn't
> contain any information indicating that the directory leads to a DFS
> lookup.

I already merged your patch and don't see a problem with those lines -
but was just noting that I could only test it on cifs - we can't test
it in the more important use cases (SMB2.1, SMB3) due to what I
pointed out in the earlier note.



-- 
Thanks,

Steve
