From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH v7 0/7] Add O_DENY* support for VFS and CIFS/NFS
Date: Tue, 21 Jan 2014 17:31:39 +0400
Message-ID: <CAKywueQng9=u1YYwkYGCunWW8RBhARhJjEhBcoA6CKF6TrKSBg@mail.gmail.com>
References: <1389953232-9428-1-git-send-email-piastry@etersoft.ru>
	<E1W5A0e-000MT9-A1@intern.SerNet.DE>
	<CAKywueQwfFASPpevO8Z-_xwZqRjkzfkOceQJDya8D7FDW+UmMg@mail.gmail.com>
	<E1W5C8U-000ozD-Ku@intern.SerNet.DE>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Linux NFS Mailing list <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	wine-devel-5vRYHf7vrtgdnm+yROfE0A@public.gmane.org
To: "Volker.Lendecke-PS7XAnAlDA+VvDNblw4Uiw@public.gmane.org" <Volker.Lendecke-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <E1W5C8U-000ozD-Ku-dqLtpHMqGvUyWpdLl23E4A@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-cifs.vger.kernel.org

2014/1/20 Volker Lendecke <Volker.Lendecke-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org>:
>> You can try to use O_PATH flag. It doesn't give you a delete access
>> but should be ok because further deleting will be done without file
>> descriptor -- through unlink syscall.
>
> Ok, I did not know about O_PATH. Thanks for that!
>
> So I do an open with O_PATH. How do I then make sure that
> nobody else has a O_DENYDELETE set without doing the unlink
> itself?

It's not possible with the current API to do it through open syscall.
Another possibility is to look at /proc/locks. But I think we really
need O_DELETE flag that will force a file to be removed on close - we
will be able to do O_DENYDELETE checks atomically.

-- 
Best regards,
Pavel Shilovsky.
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
