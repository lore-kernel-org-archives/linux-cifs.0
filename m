From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH v2 03/53] CIFS: Check for smb2 vs. cifs in find_tcp_session
Date: Sat, 29 Oct 2011 23:55:02 +0400
Message-ID: <CAKywueR26=ASO0-UVqNBuc6RDUFZDj_VXPtU-5aSNRE0kscJ_g@mail.gmail.com>
References: <1319831704-3572-1-git-send-email-piastry@etersoft.ru>
	<1319831704-3572-4-git-send-email-piastry@etersoft.ru>
	<20111029004046.2bf8e111@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111029004046.2bf8e111-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/10/29 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> On Fri, 28 Oct 2011 23:54:14 +0400
> Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
>
>> From: Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
>>
>> Also set ses->is_smb2 when smb2 session initialized.
>>
>
> The commit message doesn't seem to be accurate. ses->is_smb2 is not
> being set here (and doesn't seem to exist).

Good catch - will fix this. Thanks!

-- 
Best regards,
Pavel Shilovsky.
