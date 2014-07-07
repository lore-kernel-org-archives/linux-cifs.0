From: Pavel Shilovsky <pshilovsky@samba.org>
Subject: Re: Preliminary Performance Results from Pavel's SMB3 Multicredit
 (large i/o) patches
Date: Mon, 7 Jul 2014 18:08:12 +0400
Message-ID: <CAKywueSdZ9e50=ruUKxv5gWwp+rSBMrzNyirnPW_C_XgwE4gWA@mail.gmail.com>
References: <CAH2r5msLrenaH+BB48ZpCZfRAivgHL9i6VJJeXekkoYaWBZT2w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
	samba-technical <samba-technical@lists.samba.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Steve French <smfrench@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CAH2r5msLrenaH+BB48ZpCZfRAivgHL9i6VJJeXekkoYaWBZT2w@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

2014-07-04 5:31 GMT+04:00 Steve French <smfrench@gmail.com>:
> Pavel has been working on a patch series to improve performance of
> large i/o from cifs.ko when mounted with the more modern SMB3
> protocol.
>
> My initial informal performance comparisons with and without his
> patches looks very promising.
>
> For comparison purposes among protocols etc. the default rsize that
> will be negotiated is:
> - for cifs mounts to Samba server (Unix Extensions enabled by default):  1MB
> - for cifs mounts to servers that don't support the CIFS protocol Unix
> Extensions: 61440
> - for smb2/smb2.1/smb3 mounts prior to Pavel's patch series: 64K
> - for smb2.1/smb3 mounts with his patch set: 1MB (write size also
> increased from 64K to 1MB).
>
> Note that protocol versions prior to SMB2.1 supported a maximum write
> size of 64K (127K does work in some cases for cifs although rarely
> used), except for the special case of cifs with Unix extensions.
>
> Initial performance results are promising.   Using a 1GB source file
> on the server and copying it ala dd if=/mnt/sample of=/mnt/target
> bs=20M
>
> (Source and target are virtual machines on the same laptop -
> performance gains would likely be more impressive on real hardware.
> Target system was Samba server version 4.1.9 on Fedora 20. Client
> system was current mainline 3.16.0-rc3 on Ubuntu)
> With SMB3 mounts without Pavel's patches (current mainline kernel 3.16.0-rc3)
> 46MB/s
> With his patches:
> 91MB/s  (about a 2x improvement in large file copy performance)
>
> (With cifs protocol instead of smb3 the performance was in between,
> averaging about 65MB/s)
>
> With my first set of iozone runs, I 2x to 4x improvement in read
> performance with Pavel's patch set, and significant, although less
> dramatic improvements in write performance.  See below:
>
> File size set to 512000 KB
> Record Size 1024 KB
> Include close in write timing
> Command line used: iozone -s 500m -r 1m -c
> Output is in Kbytes/sec
> Time Resolution = 0.000001 seconds.
> Processor cache size set to 1024 Kbytes.
> Processor cache line size set to 32 bytes.
> File stride size set to 17 * record size.
>
> New module, smb3 mounts:
>                                                             random
> random    bkwd   record   stride
>               KB  reclen   write rewrite    read    reread    read
> write    read  rewrite     read   fwrite frewrite   fread  freread
>           512000    1024  102225  118000   272040   276514  228472
> 184573  226345   112443   230808   187307   185719  279627   278387
>           512000    1024  140464  111514   268999   277897  225019
> 139465  238265   125377   230924   112630   111014  275391   278125
>
> Old module, prior to Pavel's paches, smb3 mounts:
>           512000    1024   99480  100647    76163    76199   78331
> 108361   74927   108555    77629   100585   100621   76882    77539
>           512000    1024   97903  142542    72895    75871   79708
> 108268   76519   105839    78979   122057   107614   75624    73454

The testing of Ubuntu virtual machine (guest) and Windows 8.1 share
(host) gave the following results: new (patched) module on smb3 mount
is about 27% faster in reading and about 32% faster in writing than
the non-patched one.

For more details:
http://pshilovsky.blogspot.ru/2014/07/gsoc-2014-smb21-multicredit-io.html

-- 
Best regards,
Pavel Shilovsky.
