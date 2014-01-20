From: Pavel Shilovsky <piastry@etersoft.ru>
Subject: Re: [PATCH v7 0/7] Add O_DENY* support for VFS and CIFS/NFS
Date: Mon, 20 Jan 2014 14:20:43 +0400
Message-ID: <CAKywueQwfFASPpevO8Z-_xwZqRjkzfkOceQJDya8D7FDW+UmMg@mail.gmail.com>
References: <1389953232-9428-1-git-send-email-piastry@etersoft.ru>
	<E1W5A0e-000MT9-A1@intern.SerNet.DE>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-cifs <linux-cifs@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Linux NFS Mailing list <linux-nfs@vger.kernel.org>,
	wine-devel@winehq.org
To: "Volker.Lendecke@SerNet.DE" <Volker.Lendecke@sernet.de>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <E1W5A0e-000MT9-A1@intern.SerNet.DE>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

2014/1/20 Volker Lendecke <Volker.Lendecke@sernet.de>:
> Hi!
>
> On Fri, Jan 17, 2014 at 02:07:05PM +0400, Pavel Shilovsky wrote:
>> If O_DENYDELETE flag is specified and the open succeded,
>> any further unlink operation will fail with -ESHAREDENIED
>> untill this open is closed. Now this flag is processed by
>> VFS and CIFS filesystem. NFS returns -EINVAL for opens
>> with this flag.
>
> This looks really, really good, thanks!
>
> One question: If Samba wants to open a file for delete
> access, there's no corresponding flag in the open
> permissions. There can be the case where Samba wants to open
> *just* for future unlink, no read or write access required.
> Is there a way to achieve this atomically correct?

You can try to use O_PATH flag. It doesn't give you a delete access
but should be ok because further deleting will be done without file
descriptor -- through unlink syscall.

-- 
Best regards,
Pavel Shilovsky.
