From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: fix wsize patch
Date: Sat, 21 Jun 2014 18:21:09 -0500
Message-ID: <CAH2r5mvKO7J_zD2vBH=Jmp-OU3=bNm4PLN+KVBHGnrobr8m-Gg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Pavel,
Does this patch of yours, which fixes the problem if server shrinks
negotiated wsize on rsmb2/smb3 econnect, need to go in this merge
window?

http://git.altlinux.org/people/piastry/public/?p=cifs-2.6.git;a=commit;h=4c88ec0bc8275898fb6111171e7c0428294e6b78

-- 
Thanks,

Steve
