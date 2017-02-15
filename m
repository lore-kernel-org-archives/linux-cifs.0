From: Jan-Marek Glogowski <glogow-iG8UcmBuX++ELgA04lAiVw@public.gmane.org>
Subject: Re: Fix SMB2_TREE_CONNECT requests with the wrong TreeId
Date: Wed, 15 Feb 2017 15:24:44 +0100
Message-ID: <461c47b3-a4ae-c21c-26c5-b33dd19f2b37@fbihome.de>
References: <25f3edd0-3abf-f541-d7f8-54ae1dbac081@fbihome.de>
 <mps60keik2w.fsf@aaptelpc.suse.de>
 <066cc0b2-0e63-8cf6-7d46-578e524cf3bf@fbihome.de>
 <mpszihohiad.fsf@aaptelpc.suse.de>
 <1a130ab9-84bf-82cb-8c23-e071c286822c@fbihome.de>
 <mpswpcrhaet.fsf@aaptelpc.suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------A6FD777039B7ED6E5E859B7E"
To: =?UTF-8?Q?Aur=c3=a9lien_Aptel?= <aaptel-IBi9RG/b67k@public.gmane.org>,
        linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <mpswpcrhaet.fsf-zpEvHKhluMwYitT5tn2FcQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------A6FD777039B7ED6E5E859B7E
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

Am 15.02.2017 um 14:05 schrieb Aurélien Aptel:
> Jan-Marek Glogowski <glogow-iG8UcmBuX++ELgA04lAiVw@public.gmane.org> writes:
>> which is the place of the WARN call in my code. Since I also had a patch
>> for a newer kernel (Ubuntu 16.04 HWE for 14.04 AKA Linux 4.4), the
>> offsets are wrong in the attached patch.
>>
>> I just re-checked my code. I didn't test the non-WARN variant and
>> assumed the code simply got inlined, so the function name is wrong.
> 
> I've just realized WARN() itself dumps the stacktrace and that your first
> email said "expected" (not "unexpected")... *sigh* I was tired that day.
> 
> The reconnect logic is a bit convulted but patching where you did seems
> correct. Calling smb2_reconnect with the Tree Connect command will reset
> the Tid. Calling it with any command other command will end up calling
> smb2_reconnect again with the Tree Connect.
> 
>     smb2_reconnect(cmd, ...)
>       if (cmd == SMB2_TREE_CONNECT)
>           TID = 0, return
>       else    
>           SMB2_tcon()
>             small_smb2_init(SMB2_TREE_CONNECT, ...)
>               smb2_reconnect(SMB2_TREE_CONNECT, ...)
> 
> I think its clearer and more explicit if we reset the Tid everytime we
> send a Tree Con request. So in SMB2_tcon(), before the SendReceive2().

The code path is a little bit strange. I used SMB2_tcon as my "root"
when following the code paths, as it's externally used (AKA non-static)
and is assigned in the smb2ops.c as the function pointer.
So my view is a kind of "rotation" of your "call map".

My view results in SMB2_TREE_CONNECT to be just a special case of
small_smb2_init via smb2_reconnect and I expected small_smb2_init to do
the correct init. It should just modify the header (from the comment),
but it also changes the tcon, so we can't const it...

I actually never followed your "else" branch of smb2_reconnect, as it
doesn't matter for SMB2_TREE_CONNECT "init" in the SMB2_tcon call.

OTOH I don't see an easy way to make the reconnect more "sequential",
don't know a better word for non-recursive here.

I won't be able to test the patch today but hopefully tomorrow,
depending on the current LiMux stuff. I'm tired too. It compiled for my
old kernel and should work.

Jan-Marek

P.S. today I had the meeting with some people from the Hitachi NAS
support. They wanted to send me a link to a trace they made in their
test lab with our original bug. I can forward it when I get it, if still
needed.

--------------A6FD777039B7ED6E5E859B7E
Content-Type: text/x-patch;
 name="0001-Reset-TreeId-to-zero-on-SMB2_TREE_CONNECT.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-Reset-TreeId-to-zero-on-SMB2_TREE_CONNECT.patch"

>From be24636f5a7f26ef964f373ba0a79bc0553c4e4d Mon Sep 17 00:00:00 2001
From: Jan-Marek Glogowski <glogow-iG8UcmBuX++ELgA04lAiVw@public.gmane.org>
Date: Fri, 10 Feb 2017 16:43:46 +0100
Subject: [PATCH] Reset TreeId to zero on SMB2_TREE_CONNECT

Currently the cifs module breaks the CIFS specs on reconnect as
described in http://msdn.microsoft.com/en-us/library/cc246529.aspx:

"TreeId (4 bytes): Uniquely identifies the tree connect for the
command. This MUST be 0 for the SMB2 TREE_CONNECT Request."

Signed-off-by: Jan-Marek Glogowski <glogow-iG8UcmBuX++ELgA04lAiVw@public.gmane.org>
---
 fs/cifs/smb2pdu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 8745722..8f310672 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1115,7 +1115,8 @@ static inline void init_copy_chunk_defaults(struct cifs_tcon *tcon)
 		req->hdr.SessionId = ses->Suid;
 		/* if (ses->server->sec_mode & SECMODE_SIGN_REQUIRED)
 			req->hdr.Flags |= SMB2_FLAGS_SIGNED; */
-	}
+	} else
+		tcon->tid = 0;
 
 	iov[0].iov_base = (char *)req;
 	/* 4 for rfc1002 length field and 1 for pad */
-- 
1.9.1


--------------A6FD777039B7ED6E5E859B7E--
