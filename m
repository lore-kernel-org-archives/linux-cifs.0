From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [CIFS] Charge at least one credit, if server says that it
 supports multicredit
Date: Wed, 26 Jun 2013 17:55:48 -0500
Message-ID: <CAH2r5muFAgQA5YNZ351V1Kkmar6bkGOH6_W+6bFapSO2Zxm2FA@mail.gmail.com>
References: <20130624122449.GA14149@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130624122449.GA14149-mgFCXtclrQlZLf2FXnZxJA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Fixed.  Thanks for pointing this out

Author: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Date:   Wed Jun 26 17:52:17 2013 -0500

    [CIFS] fix static checker warning

    Dan Carpenter wrote:

    The patch 7f420cee8bd6: "[CIFS] Charge at least one credit, if server
    says that it supports multicredit" from Jun 23, 2013, leads to the
    following Smatch complaint:

    fs/cifs/smb2pdu.c:120 smb2_hdr_assemble()
             warn: variable dereferenced before check 'tcon->ses' (see line 115)

    CC: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
    Signed-off-by: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index f9b74da..53275bf 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -111,7 +111,8 @@ smb2_hdr_assemble(struct smb2_hdr *hdr, __le16 smb2_cmd /* c
        /* BB FIXME when we do write > 64K add +1 for every 64K in req or rsp */
        /* GLOBAL_CAP_LARGE_MTU will only be set if dialect > SMB2.02 */
        /* See sections 2.2.4 and 3.2.4.1.5 of MS-SMB2 */
-       if (tcon->ses->server->capabilities & SMB2_GLOBAL_CAP_LARGE_MTU)
+       if ((tcon->ses) &&
+           (tcon->ses->server->capabilities & SMB2_GLOBAL_CAP_LARGE_MTU))
                hdr->CreditCharge = cpu_to_le16(1);
        /* else CreditCharge MBZ */


On Mon, Jun 24, 2013 at 7:24 AM, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> Hello Steve French,
>
> This is a semi-automatic email about new static checker warnings.
>
> The patch 7f420cee8bd6: "[CIFS] Charge at least one credit, if server
> says that it supports multicredit" from Jun 23, 2013, leads to the
> following Smatch complaint:
>
> fs/cifs/smb2pdu.c:120 smb2_hdr_assemble()
>          warn: variable dereferenced before check 'tcon->ses' (see line 115)
>
> fs/cifs/smb2pdu.c
>    114          if (tcon->ses->server->capabilities & SMB2_GLOBAL_CAP_LARGE_MTU)
>                     ^^^^^^^^^^^
> New dereference.
>
>    115                  hdr->CreditCharge = cpu_to_le16(1);
>    116          /* else CreditCharge MBZ */
>    117
>    118          hdr->TreeId = tcon->tid;
>    119          /* Uid is not converted */
>    120          if (tcon->ses)
>                     ^^^^^^^^^
> Old check.
>
>    121                  hdr->SessionId = tcon->ses->Suid;
>    122          /* BB check following DFS flags BB */
>
> regards,
> dan carpenter



-- 
Thanks,

Steve
