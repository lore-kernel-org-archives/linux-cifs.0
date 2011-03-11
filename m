From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] [CIFS] do not try to dump cifs mids from smb2 sessions
Date: Fri, 11 Mar 2011 12:27:20 -0600
Message-ID: <AANLkTin5tuWSkbjgncRCGmh7tzN04Kvc5=6OZqYqGPWM@mail.gmail.com>
References: <AANLkTikoOp4DfA1dCeRPvom=OG5i0WNpAEjBSX2U6TbK@mail.gmail.com>
	<AANLkTinDbqDtkjQYR0pOjhW8qVUKOtpBZFJy4yqKqPU4@mail.gmail.com>
	<AANLkTim_8y12TM0ekf16dvQdo7okXnB23GK5dxqW_fwX@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTim_8y12TM0ekf16dvQdo7okXnB23GK5dxqW_fwX-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Mar 11, 2011 at 12:14 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wro=
te:
> On Fri, Mar 11, 2011 at 12:06 PM, Shirish Pargaonkar
> <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> On Thu, Mar 10, 2011 at 10:33 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> =
wrote:
>>> [PATCH] [CIFS] do not try to dump cifs mids from smb2 sessions
>>>
>>> Convert the debug routines in cifs_debug.c to recognize
>>> smb2 sessions and not try to dump invalid information on
>>> pending requests. =A0Check the socket type to see if
>>> smb2. =A0Move the printing of cifs specific debug information
>>> to a helper routine to make it clearer which type
>>> of information we are printing.
>>>
>>> cifs and smb2 both use the struct TCP_Server_Info to include inform=
ation about
>>> the tcp socket connection to the server. =A0The list of pending req=
uests
>>> is one of the "per-socket" pieces of information.
> <snip>
>
>> I suppose there would not be a smb2_tcp_ses_lock!
> Right - with Jeff's suggestions about trying to share more
> of the transport code and cifs structures, the size of the
> three structures increases (to accommodate protocol
> enhancements) but we can reuse more of the transport code
> and use cifs's tcp_ses_lock and don't need an smb2 version
> of that.
> - struct TCP_Server_Info (per-socket, ie tcp session info)> - struct =
cifs_ses (per user info for each socket, ie smb session info)
> - struct cifs_tcon (each share that we are connected to for each cifs=
_ses)
>
>> Also, although I have not see any issues, is it ok to take a spinloc=
k
>> within a spinlock (GloablMid_Lock while holding cifs_tcp_ses_lock)?
>
> It is better not to nest spinlocks of course, but in this case we are
> careful to take them in the right order, and this is unchanged from
> the existing cifs code.

I did have a trivial typo (just corrected see below)

--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -109,7 +109,7 @@ void cifs_dump_mids(struct TCP_Server_Info *server)
 static void dump_smb2_debug_info(int i, struct seq_file *m,
                                struct TCP_Server_Info *server)
 {
-       seq_printf("dumping debug information for smb2 not supported ye=
t\n");
+       seq_printf(m, "dumping debug information for smb2 not supported=
 yet\n");
 }

 static void dump_cifs_debug_info(int i, struct seq_file *m,



--=20
Thanks,

Steve
