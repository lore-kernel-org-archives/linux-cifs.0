From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Creating sparse files on Linux
Date: Mon, 21 Jul 2014 15:02:06 -0500
Message-ID: <CAH2r5mvc-RxzTS2Ov_35Svpzs-xUmnjhXpQ3tSAk0csn8YbidA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I noticed that some Linux file systems (including ext4) create sparse
files by default in this scenario

dd if=/dev/zero of=/mnt/test/16M bs=1M count=0 seek=16

(which creates a 16MB sparse file)

but over cifs/smb2/smb3 this does not create a sparse file (and
probably should).

http://blogs.msdn.com/b/openspecification/archive/2010/11/05/notes-on-sparse-files-and-file-sharing.aspx

http://prefetch.net/blog/index.php/2009/07/05/creating-sparse-files-on-linux-hosts-with-dd/

-- 
Thanks,

Steve
