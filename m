From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: question about potential integer truncation in cifs_set_file_size
Date: Mon, 28 Sep 2015 15:57:09 -0500
Message-ID: <CAH2r5mvWtbsru8HAphsGhukP-YHNSF+99D9v1BbBbNMeiaeCAw@mail.gmail.com>
References: <5606AC37.16935.51F2ED39@pageexec.freemail.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, re.emese-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
	spender-JNS0hek0TMl4qEwOxq4T+Q@public.gmane.org
To: pageexec-Y8qEzhMunLyT9ig0jae3mg@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5606AC37.16935.51F2ED39-tVCe0bXVy/VhMnff8nq0I0CAg8bcNmFB@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, Sep 26, 2015 at 9:31 AM, PaX Team <pageexec-Y8qEzhMunLyT9ig0jae3mg@public.gmane.org> wrote:
> hi all,
>
> fs/cifs/inode.c:cifs_set_file_size can truncate iattr.ia_size from loff_t
> (long long) to unsigned int here:
>
>         io_parms.length = attrs->ia_size;
>
> and i'm wondering if this is intentional. based on a quick read of the code,
> it seems that ia_size can at this point have a value over 4G (e.g., via a
> call to truncate) and the ->set_file_size callback will transmit the full
> 64 bit value however in case of specific failures a (fallback?) call to
> CIFSSMBWrite would be made with the truncated size.

Good catch.  The bug here is in an error path that you probably
wouldn't notice except to very very old Windows (or DOS!) systems (ie
even before Window 2000) or
perhaps when mounted to buggy CIFS servers which don't support the
normal SetFileInfo
levels.  The actual bug is that the length and offsets fields are
backwards. Fortunately,
this code path returns immediately from write (since the length is
non-zero with a buffer
pointer of zero) without doing damage, and you wouldn't even notice
the bug since most every CIFS server supports the normal way of
setting the file size (via SetFileInfo) and
doesn't require falling back to the DOS (!) way of setting file size
by writing zero bytes
at an offset.

> FTR, this issue was detected with the upcoming version of the size overflow
> plugin we have in PaX/grsecurity and there're a handful of similar cases in
> the tree where potentially unwanted or unnecessary integer truncations occur,
> this being one of these. any opinion/help is welcome!

If you find others let me know (other than the identical bug in the
error path immediately below the one you just pointed out).

-- 
Thanks,

Steve
