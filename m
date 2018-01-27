From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: Fwd: [PATCH] cifs: add .splice_write
Date: Sat, 27 Jan 2018 07:31:32 -0700
Message-ID: <f29bddaa-62b5-046d-70f9-b809fd41a1d7@kernel.dk>
References: <20171228132308.5709-1-kai670@gmail.com>
 <20180126181320.hc3sz4hyrfytj5d2@Dell-XPS-L322X>
 <CAH2r5mvgTBdwBgsA4r0x7KiuLEzW2YeU4Hz+PUeYyvooMCSN4g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: CIFS <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        =?UTF-8?Q?Andr=c3=a9s_Souto?= <kai670-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mvgTBdwBgsA4r0x7KiuLEzW2YeU4Hz+PUeYyvooMCSN4g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 1/26/18 2:25 PM, Steve French wrote:
> The patch did look like it improves the performance of file copy from
> Nautilus when I tried it, but would prefer experimenting tool where I
> could measure the improvement more precisely.  Is there a good command
> line tool which generates splice_write indirectly? As expected cp and
> dd don't seem to be affected by this patch.

You can use fio with ioengine=splice. Or if you have any sendfile()
based tools, that should also do the trick, as sendfile() is just
a wrapper around splice.

-- 
Jens Axboe
