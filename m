From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] CIFS: Fix a possible invalid memory access in smb2_query_symlink()
Date: Thu, 28 Jul 2016 08:27:22 +0300
Message-ID: <CAKywueSPKWufYLCp3+1cmN5QXus+x4EEN4tJAHZO7V5jYZwnoA@mail.gmail.com>
References: <1469345858-5571-1-git-send-email-piastry@altlinux.org>
 <CAH2r5muh2_khdSDT55t1fTerm4qqY2jBaper-Eh9GtaAbX08zA@mail.gmail.com>
 <0C08296C-E9E7-431D-905A-B85D425814B8@gmail.com> <CAH2r5mv6OmKbex9vQCxxVaoH25+=-HjShzfdUFonfhLspZay5A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mv6OmKbex9vQCxxVaoH25+=-HjShzfdUFonfhLspZay5A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2016-07-28 8:04 GMT+03:00 Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> I lightly updated the patch to fix the endian warning and pushed to
> cifs-2.6.git for-next
>
> https://git.samba.org/?p=sfrench/cifs-2.6.git;a=commitdiff;h=7893242e2465aea6f2cbc2639da8fa5ce96e8cc2

Thanks!

-- 
Best regards,
Pavel Shilovsky
