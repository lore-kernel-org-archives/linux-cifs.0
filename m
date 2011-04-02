From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: wrap received signature check in srv_mutex
Date: Sat, 2 Apr 2011 13:42:41 -0500
Message-ID: <BANLkTikCXYdpQZcgN=SauC_b4zJH2Hiy+A@mail.gmail.com>
References: <1301744070-30667-1-git-send-email-jlayton@redhat.com>
	<20110402073738.534eec0a@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110402073738.534eec0a-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, Apr 2, 2011 at 6:37 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Sat, =A02 Apr 2011 07:34:30 -0400
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
>> While testing my patchset to fix asynchronous writes, I hit a bunch
>> of signature problems when testing with signing on. The problem seem=
s
>> to be that signature checks on receive can be running at the same
>> time as a process that is sending, or even that multiple receives ca=
n
>> be checking signatures at the same time, clobbering the same data
>> structures.
>>
>> While we're at it, clean up the comments over cifs_calculate_signatu=
re
>> and add a note that the srv_mutex should be held when calling this
>> function.
>>
>> This patch seems to fix the problems for me, but I'm not clear on
>> whether it's the best approach. If it is, then this should probably
>> go to stable too.
>>
>> Cc: stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
>> Cc: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> ---
>> =A0fs/cifs/cifsencrypt.c | =A0 15 +++++++++------
>> =A01 files changed, 9 insertions(+), 6 deletions(-)
>>
>> diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
>> index 5bb4b09..dfbd9f1 100644
>> --- a/fs/cifs/cifsencrypt.c
>> +++ b/fs/cifs/cifsencrypt.c
>> @@ -30,12 +30,13 @@
>> =A0#include <linux/ctype.h>
>> =A0#include <linux/random.h>
>>
>> -/* Calculate and return the CIFS signature based on the mac key and=
 SMB PDU */
>> -/* the 16 byte signature must be allocated by the caller =A0*/
>> -/* Note we only use the 1st eight bytes */
>> -/* Note that the smb header signature field on input contains the
>> - =A0 =A0 sequence number before this function is called */
>> -
>> +/*
>> + * Calculate and return the CIFS signature based on the mac key and=
 SMB PDU.
>> + * The 16 byte signature must be allocated by the caller. Note we o=
nly use the
>> + * 1st eight bytes and that the smb header signature field on input=
 contains
>> + * the sequence number before this function is called. Also, this f=
unction
>> + * should be called with the server->srv_mutex held.
>> + */
>> =A0static int cifs_calculate_signature(const struct smb_hdr *cifs_pd=
u,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct T=
CP_Server_Info *server, char *signature)
>> =A0{
>> @@ -209,8 +210,10 @@ int cifs_verify_signature(struct smb_hdr *cifs_=
pdu,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 cpu_to_le32(expected_sequence_number);
>> =A0 =A0 =A0 cifs_pdu->Signature.Sequence.Reserved =3D 0;
>>
>> + =A0 =A0 mutex_lock(&server->srv_mutex);
>> =A0 =A0 =A0 rc =3D cifs_calculate_signature(cifs_pdu, server,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 what_we_think_sig_should_be);
>> + =A0 =A0 mutex_unlock(&server->srv_mutex);
>>
>> =A0 =A0 =A0 if (rc)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>
> Also, on a semi-related note. I consistently get this error on sessio=
n
> setup with krb5i, with or without the above patch:
>
> [ =A0842.563693] CIFS VFS: Unexpected SMB signature
>
> I set up the kernel to dump the stack there and get this:
>
> [ =A0842.564981] Pid: 1530, comm: mount.cifs Not tainted 2.6.38-1.fc1=
5.x86_64.debug #1
> [ =A0842.566958] Call Trace:
> [ =A0842.567658] =A0[<ffffffffa00fca75>] ? cifs_check_receive+0x6e/0x=
84 [cifs]
> [ =A0842.569415] =A0[<ffffffffa00fccf6>] ? SendReceive2+0x26b/0x2cd [=
cifs]
> [ =A0842.571079] =A0[<ffffffffa0102128>] ? CIFS_SessSetup+0x88e/0xe36=
 [cifs]
> [ =A0842.572724] =A0[<ffffffffa00ee4db>] ? cifs_setup_session+0x90/0x=
1ae [cifs]
> [ =A0842.574551] =A0[<ffffffffa00ee9b3>] ? cifs_get_smb_ses+0x3ba/0x4=
7e [cifs]
> [ =A0842.576257] =A0[<ffffffffa00f0627>] ? cifs_mount+0x1bb0/0x21c5 [=
cifs]
> [ =A0842.577944] =A0[<ffffffffa00e1b1c>] ? cifs_do_mount+0x191/0x309 =
[cifs]
> [ =A0842.579612] =A0[<ffffffff81136544>] ? vfs_kern_mount+0xaa/0x1d7
> [ =A0842.581093] =A0[<ffffffff811366d9>] ? do_kern_mount+0x4d/0xdf
> [ =A0842.582554] =A0[<ffffffff8114e4bf>] ? do_mount+0x6a4/0x6f8
> [ =A0842.583986] =A0[<ffffffff8114e793>] ? sys_mount+0x88/0xc2
> [ =A0842.585354] =A0[<ffffffff81009b82>] ? system_call_fastpath+0x16/=
0x1b
>
> ...it seems like the signature checking on session setup is always
> wrong. After that though, I don't see any similar problems.
>
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>

I think it is the first packet  during session setup that cifs need not
verify signature, so type 1 packet signature check in  either kerberos
within  ntlmp or ntlmv2 within ntlmssp using nlmp will see such errors.
