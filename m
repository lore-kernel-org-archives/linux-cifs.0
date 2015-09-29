From: "PaX Team" <pageexec-Y8qEzhMunLyT9ig0jae3mg@public.gmane.org>
Subject: Re: question about potential integer truncation in cifs_set_file_size
Date: Tue, 29 Sep 2015 13:02:35 +0200
Message-ID: <560A6FCB.6228.60A6C7EA@pageexec.freemail.hu>
References: <5606AC37.16935.51F2ED39@pageexec.freemail.hu>, <CAH2r5mvWtbsru8HAphsGhukP-YHNSF+99D9v1BbBbNMeiaeCAw@mail.gmail.com>
Reply-To: pageexec-Y8qEzhMunLyT9ig0jae3mg@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, re.emese-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
	spender-JNS0hek0TMl4qEwOxq4T+Q@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <CAH2r5mvWtbsru8HAphsGhukP-YHNSF+99D9v1BbBbNMeiaeCAw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-description: Mail message body
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 28 Sep 2015 at 15:57, Steve French wrote:

> > FTR, this issue was detected with the upcoming version of the size overflow
> > plugin we have in PaX/grsecurity and there're a handful of similar cases in
> > the tree where potentially unwanted or unnecessary integer truncations occur,
> > this being one of these. any opinion/help is welcome!
> 
> If you find others let me know (other than the identical bug in the
> error path immediately below the one you just pointed out).

sure, i will, though the current (very specific) analysis found only
those questionable cases that i reported (here and some other lists).
if you (or anyone else) have ideas for more specific analysis (checking
invariants, API use, etc), we can take a look though gcc plugins have
very limited view on the source code, so only those properties can be
checked that are still visible in the middle end (we found the above
case exactly because the underlying code looks the same whether the
integer truncation is intentional or not, so we had to exclude them
as false positives in our instrumentation but still wanted to manually
verify them).

PS: it seems that you didn't CC me on the actual patch ;)
