From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: copy chunk preliminary results
Date: Mon, 4 Nov 2013 00:30:56 -0600
Message-ID: <CAH2r5mtoGCn-z_-Aetwaxxvn8bS19mexb7Rur3TE=RGipGCppQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I extended my initial copy chunk kernel client patch to handle files >
1MB (repeating copychunk requests multiple times, 1 chunk at a time, I
realize that this will be even faster when I send more than 1 chunk at
a time)

Preliminary results local loopback mount of current cifs kernel code
(vers=3.0) to Samba (master branch, running on Fedora 19 with btrfs):

File size of test file (vmlinux.o) was 373987044 bytes

Over the network Copychunk (refcopy) was about six times faster than without.
ane even local copy (no reflink) is slower than remote copy with
reflink.  Copychunk would look even better except that the server disk
is SSD.


[sfrench@pc-on-right cifs-2.6]$ time cp vmlinux.o ~/trgt-1-local
real    0m0.769s
user    0m0.002s
sys    0m0.502s

(Local copy with reflink is amazingly fast on btrfs)
[sfrench@pc-on-right cifs-2.6]$ time cp --reflink vmlinux.o
~/trgt-2-local-reflink
real    0m0.004s
user    0m0.001s
sys    0m0.002s

(remote copy with reflink to Samba was six times faster than remote
with no reflink, similar results when repeated)
[sfrench@pc-on-right cifs-2.6]$ time cp --reflink
/mnt/cifs-2.6/vmlinux.o /mnt/trgt-3-remote-reflink
real    0m0.416s
user    0m0.000s
sys    0m0.029s


[sfrench@pc-on-right cifs-2.6]$ time cp  /mnt/cifs-2.6/vmlinux.o
/mnt/trgt-3-no-reflink
real    0m2.596s
user    0m0.007s
sys    0m0.860s



-- 
Thanks,

Steve
