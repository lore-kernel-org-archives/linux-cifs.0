From: Enda <enda_k2-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 02/18] xstat: Add a pair of system calls to make extended file stats available [ver #6]
Date: Wed, 17 Jul 2013 14:03:07 +0000 (UTC)
Message-ID: <loom.20130717T160052-124@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Copying a file using cp on a NTFS filesystem to an ext4 filesystem does not 
copy the birth time:

$ cp --preserve=all ntfs.txt ~

$ stat ~/ntfs.txt 
...
 Birth: -



-- Enda
