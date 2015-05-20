From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [CIFS] fix static checker warning
Date: Wed, 20 May 2015 11:21:53 -0500
Message-ID: <CAH2r5msQk_OQWEiPcUGRx6_PdddraoQ9jbt-+t7y-rQeJaHjAg@mail.gmail.com>
References: <20150518123344.GE32633@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150518123344.GE32633@mwanda>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Thanks for finding this -

I just put a patch in cifs-2.6.git for-next for this

https://git.samba.org/?p=sfrench/cifs-2.6.git;a=commit;h=1dc92c450a53f120b67296cb4b29c1dfdc665ac1

On Mon, May 18, 2015 at 7:33 AM, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
>
> [ I recently changed the checker so now it gives a new warning about
>   this old code. ]
>
> Hello Steve French,
>
> The patch 84ceeb962665: "[CIFS] fix static checker warning" from Jun
> 26, 2013, leads to the following static checker warning:
>
>         fs/cifs/smb2pdu.c:136 smb2_hdr_assemble()
>         warn: variable dereferenced before check 'tcon->ses->server' (see line 120)
>
> fs/cifs/smb2pdu.c
>    111          /* GLOBAL_CAP_LARGE_MTU will only be set if dialect > SMB2.02 */
>    112          /* See sections 2.2.4 and 3.2.4.1.5 of MS-SMB2 */
>    113          if ((tcon->ses) &&
>    114              (tcon->ses->server->capabilities & SMB2_GLOBAL_CAP_LARGE_MTU))
>                      ^^^^^^^^^^^^^^^^^
> Dereferenced without a check.
>
>    115                  hdr->CreditCharge = cpu_to_le16(1);
>    116          /* else CreditCharge MBZ */
>    117
>    118          hdr->TreeId = tcon->tid;
>    119          /* Uid is not converted */
>    120          if (tcon->ses)
>    121                  hdr->SessionId = tcon->ses->Suid;
>    122
>    123          /*
>    124           * If we would set SMB2_FLAGS_DFS_OPERATIONS on open we also would have
>    125           * to pass the path on the Open SMB prefixed by \\server\share.
>    126           * Not sure when we would need to do the augmented path (if ever) and
>    127           * setting this flag breaks the SMB2 open operation since it is
>    128           * illegal to send an empty path name (without \\server\share prefix)
>    129           * when the DFS flag is set in the SMB open header. We could
>    130           * consider setting the flag on all operations other than open
>    131           * but it is safer to net set it for now.
>    132           */
>    133  /*      if (tcon->share_flags & SHI1005_FLAGS_DFS)
>    134                  hdr->Flags |= SMB2_FLAGS_DFS_OPERATIONS; */
>    135
>    136          if (tcon->ses && tcon->ses->server && tcon->ses->server->sign)
>                                  ^^^^^^^^^^^^^^^^^
>
> Checked too late.
>
>    137                  hdr->Flags |= SMB2_FLAGS_SIGNED;
>    138  out:
>    139          pdu->StructureSize2 = cpu_to_le16(parmsize);
>    140          return;
>
> regards,
> dan carpenter



-- 
Thanks,

Steve
