From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH] CIFS: Fix NT_STATUS_ACCESS_DENIED for mounts with
 prefixpath option
Date: Wed, 31 Aug 2011 22:27:25 +0400
Message-ID: <CAKywueTh-XVrmRH-7AwedShAhmAmFAHs9fsOALrZpkzMhemP=Q@mail.gmail.com>
References: <1314341541-2476-1-git-send-email-piastry@etersoft.ru>
	<CAKywueRzwQPROzWTNwhbSOeEanV+Pumn=vFDmYL0uuEApfsX9A@mail.gmail.com>
	<20110830085935.71e671e4@corrin.poochiereds.net>
	<CAKywueSy2tFQC4mxOBZYjiY=PyLjUZ44v+qvtNNg+zKoxJmeCw@mail.gmail.com>
	<20110831140044.5ac4a691@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110831140044.5ac4a691-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/8/31 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> I think you need to make sure you're holding the i_mutex of the parent
> for this. Most of these sorts of dentry operations require it.
>

In the case of this patch, we can have a negative parent - so, can't
hold i_mutex here. It seems to me that we need extra cifs mutex for
dealing this it.

-- 
Best regards,
Pavel Shilovsky.
