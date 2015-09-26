From: "PaX Team" <pageexec-Y8qEzhMunLyT9ig0jae3mg@public.gmane.org>
Subject: question about potential integer truncation in cifs_set_file_size
Date: Sat, 26 Sep 2015 16:31:19 +0200
Message-ID: <5606AC37.16935.51F2ED39@pageexec.freemail.hu>
Reply-To: pageexec-Y8qEzhMunLyT9ig0jae3mg@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, re.emese-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
	spender-JNS0hek0TMl4qEwOxq4T+Q@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-description: Mail message body
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

hi all,

fs/cifs/inode.c:cifs_set_file_size can truncate iattr.ia_size from loff_t
(long long) to unsigned int here:

	io_parms.length = attrs->ia_size;

and i'm wondering if this is intentional. based on a quick read of the code,
it seems that ia_size can at this point have a value over 4G (e.g., via a
call to truncate) and the ->set_file_size callback will transmit the full
64 bit value however in case of specific failures a (fallback?) call to
CIFSSMBWrite would be made with the truncated size.

FTR, this issue was detected with the upcoming version of the size overflow
plugin we have in PaX/grsecurity and there're a handful of similar cases in
the tree where potentially unwanted or unnecessary integer truncations occur,
this being one of these. any opinion/help is welcome!

cheers,
  PaX Team
