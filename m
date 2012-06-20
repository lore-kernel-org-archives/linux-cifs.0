From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 01/22] CIFS: Add SMB2 status codes
Date: Wed, 20 Jun 2012 11:49:01 +0400
Message-ID: <CAKywueRzeAV2P-nO=K3kpVaLoh=i462kaLaLGgJvEs4Mrteh1w@mail.gmail.com>
References: <1340109611-7210-1-git-send-email-pshilovsky@samba.org>
	<1340109611-7210-2-git-send-email-pshilovsky@samba.org>
	<20120619152207.6d48ec92@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120619152207.6d48ec92-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2012/6/20 Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
> On Tue, 19 Jun 2012 16:39:50 +0400
> Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
>
>> +#define STATUS_GUARD_PAGE_VIOLATION =A0 0x80000001
>> +#define STATUS_DATATYPE_MISALIGNMENT =A00x80000002
>> +#define STATUS_BREAKPOINT =A0 =A0 0x80000003
>> +#define STATUS_SINGLE_STEP =A0 =A00x80000004
>> +/* #define STATUS_BUFFER_OVERFLOW =A0 =A0 0x80000005 */
>> +#define STATUS_NO_MORE_FILES =A00x80000006
>> +#define STATUS_WAKE_SYSTEM_DEBUGGER =A0 0x80000007
>> +#define STATUS_HANDLES_CLOSED =A0 =A0 =A0 =A0 0x8000000A
>> +#define STATUS_NO_INHERITANCE =A0 =A0 =A0 =A0 0x8000000B
>> +#define STATUS_GUID_SUBSTITUTION_MADE =A0 =A0 =A0 =A0 0x8000000C
>
> Well, on the plus side, you did comment out STATUS_BUFFER_OVERFLOW
> which was a definite conflict with the definitions in the SMB1 status
> code list. However...I'm fairly certain that there are other conflict=
s
> here, so that was just an example.
>
> You really have two choices here:
>
> 1) make smb2status.h and nterr.h be mutually exclusive. Ensure that y=
ou
> never #include both files. At first glance, this may be easy, but the
> trick will be to ensure that no one does this in the future.
>
> 2) rename all of these error codes such that they do not conflict wit=
h
> the SMB1 errors. This is more certain to ensure that you don't have
> problems, but it's a bigger change.
>
> I really don't care which one you choose, but we really do need to ta=
ke
> steps to ensure that we do not get conflicts here.
>
> --
> Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>

nterr.h has only 5 macros started with STATUS_:

#define STATUS_MORE_ENTRIES               0x0105
#define STATUS_1804>----                  0x070c
#define STATUS_NOTIFY_ENUM_DIR            0x010c
#define STATUS_SOME_UNMAPPED       0x0107
#define STATUS_BUFFER_OVERFLOW     0x80000005

I've already checked all them and commented dublicates in smb2status.h
(STATUS_MORE_ENTRIES, STATUS_NOTIFY_ENUM_DIR, STATUS_BUFFER_OVERFLOW)
- no conflicts now.

But I don't care to rename all error codes to something like
SMB2_STATUS_ to make sure we will not miss something in future.

--=20
Best regards,
Pavel Shilovsky.
