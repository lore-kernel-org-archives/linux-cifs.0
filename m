From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 6/9] CIFS: Separate filling pages from iovec write
Date: Thu, 26 Jun 2014 13:33:13 +0400
Message-ID: <CAKywueQao8-Oqi_OwM8yKu63LcYUL8jCd4h7kTt6y8_ZJ7YPwQ@mail.gmail.com>
References: <1403535517-8301-1-git-send-email-pshilovsky@samba.org>
	<1403535517-8301-7-git-send-email-pshilovsky@samba.org>
	<CAH2r5mvK-co524mw8yEsA3-EbzpeRG2rO+FurGJ5CThbwQdLYg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mvK-co524mw8yEsA3-EbzpeRG2rO+FurGJ5CThbwQdLYg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2014-06-26 9:46 GMT+04:00 Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> FYI - merge conflict in current cifs-2.6.git for-next (and current
> mainline kernel) due to Al Viro's read_iter and write_iter changes.
>
> Presumably due to changeset
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/fs/cifs?id=16b9057804c02e2d351e9c8f606e909b43cbd9e7
>
> Would you rebase on current cifs-2.6.git or current mainline from this patch on?

Yes, I started to do it but noticed that the existing code (without my
patches) has data coherency problem on reconnect during reading when
mounting with cache=none. Now, I am investigating this.

-- 
Best regards,
Pavel Shilovsky.
