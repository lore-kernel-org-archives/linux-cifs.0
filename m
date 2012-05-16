From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH v4 3/5] CIFS: Separate protocol specific lock type handling
Date: Wed, 16 May 2012 23:16:27 +0400
Message-ID: <CAKywueSo1PM6wfq2Aa-nVMfxW0=GX7BATDFmeN2CV+RdAGfTxg@mail.gmail.com>
References: <1337162254-13121-1-git-send-email-piastry@etersoft.ru>
	<1337162254-13121-4-git-send-email-piastry@etersoft.ru>
	<20120516142500.531aca81@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120516142500.531aca81-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2012/5/16 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> On Wed, 16 May 2012 13:57:32 +0400
> Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
>
>> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
>> ---
>> =A0fs/cifs/cifsglob.h | =A0 =A04 ++++
>> =A0fs/cifs/file.c =A0 =A0 | =A0 40 ++++++++++++++++++++++++---------=
-------
>> =A0fs/cifs/smb1ops.c =A0| =A0 =A05 +++++
>> =A03 files changed, 33 insertions(+), 16 deletions(-)
>>
>> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
>> index 0e06de1..6943448 100644
>> --- a/fs/cifs/cifsglob.h
>> +++ b/fs/cifs/cifsglob.h
>> @@ -164,6 +164,10 @@ struct smb_version_operations {
>>
>> =A0struct smb_version_values {
>> =A0 =A0 =A0 char =A0 =A0 =A0 =A0 =A0 =A0*version_string;
>> + =A0 =A0 __u32 =A0 =A0 =A0 =A0 =A0 large_lock_type;
>> + =A0 =A0 __u32 =A0 =A0 =A0 =A0 =A0 exclusive_lock_type;
>> + =A0 =A0 __u32 =A0 =A0 =A0 =A0 =A0 shared_lock_type;
>> + =A0 =A0 __u32 =A0 =A0 =A0 =A0 =A0 unlock_lock_type;
>> =A0};
>>
>
> It would probably be good to send your respin of my patchset so that =
we
> can see what this one is based on...
>

Yes - posted.

--=20
Best regards,
Pavel Shilovsky.
