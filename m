From: Michael Kerscher <michael-h4kDu0VMPndVshqcic2dkxvVK+yQ3ZXh@public.gmane.org>
Subject: incomplete FIND_FIRST2 response and resulting cifs behavior
Date: Mon, 08 Dec 2014 01:59:26 +0100
Message-ID: <5484F7EE.8070309@kerscher-michael.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060302090406040606010809"
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Maximilian Engelhardt <maximilian.engelhardt-k8VSl6tcS6nF41mA0N3lWw@public.gmane.org>
To: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060302090406040606010809
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

Hello,

we found an issue which might be sourced in the cifs module and might
only be triggered in a special case.

Our current situation:
We run a samba-4.1.13 (debian jessie) and in our share are some files
with an iso 8859-1 encoding (e.g. test_ä_foo). There are some errors in
the samba log like

[2014/12/07 20:00:52.353146,  0]
../lib/util/charset/convert_string.c:438(convert_string_talloc_handle)
  Conversion error: Illegal multibyte sequence(ä_foo)

This is an issue I will also look into but the problem is, that samba
responds to the FIND_FIRST2 request with an incomplete response. I
attached a pcap with an example which I logged on my client. The
requested directory (public/mytest) contained only a file named
test_ä_foo (in iso 8859-1 encoding) so the response contained the . and
.. directory entries and a file entry which is missing the file name
field at the end of the packet. It just stops at the num links field.

A windows client just shows an empty filename in the explorer.

If mounted on linux with cifs then I see either random characters, some
directory/file names of the parent directory (or other directories) or
ls: reading directory /mnt/tmp/public/mytest: Invalid argument
On repeated calls of ls the filename changes to some other folder names.

E.g if my directory looks like
-> public
   - test_file
   - test_foo
   -> mytest
      - test_ä_foo
then $ ls public/mytest might have the following outputs:
$ ls public/mytest
<some_random_chars>
$ ls public/mytest
test_file
$ ls public/mytest
test_file
$ ls public/mytest
test_foo

which is not what I expected (test_ä_foo)

In the attached pcap log you can see a request where there should be
included the directory entries ".", ".." and a file named "test_ä_foo".

If you need more details I'll be happy to provide them.

regards,
Michael

--------------060302090406040606010809
Content-Type: application/octet-stream;
 name="example.pcapng"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="example.pcapng"

Cg0NChwAAABNPCsaAQAAAP//////////HAAAAAEAAAAgAAAAAQAAAAAABAAJAAEABgAAAAAA
AAAgAAAABgAAANgAAAAAAAAAlAkFAFqGLba2AAAAtgAAAAAYcdznAAAfO4tWQQgARQAAqFeu
QABABkQgCpYJkwqWf8Po2wG9yl6WYQ4DrVyAGAWfAe8AAAEBCAoBZPnvCf37ugAAAHD/U01C
MgAAAAAAAcAAAAAAAAAAAAAAAABBew4eXBi7Eg8uAAAACgAAQAAAAAAAAAAAAAAuAEIAAAAA
AAEAAQAvAAAXAJYABgACAgAAAAAvAHAAdQBiAGwAaQBjAC8AbQB5AHQAZQBzAHQALwAqAAAA
AADYAAAABgAAAPwBAAAAAAAAlAkFAImdLbbaAQAA2gEAAAAfO4tWQQAYcdznAAgARQABzL2Y
QAA/Bt4RCpZ/wwqWCZMBvejbDgOtXMpeltWAGAD8wNkAAAEBCAoJ/fwuAWT57wAAAZT/U01C
MgAAAACAA8gAAAAAAAAAAAAAAABBew4eXBi7EgoKAFABAAAKADgAAABQAUQAAAAAAF0BAP3/
AwABAAAA5AAAAHAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAD80uD6tEdABmPeDn60R0AE/NLg+
rRHQASapRgQAAAAAJqlGBAAAAAABAAAACQAAAAAAAAAFAAAAAAAAAC9gyAEFCQAA7QEAAAAA
AAACAAAAAAAAAC4AAAB0AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA/NLg+rRHQAVBMCZ+tEdAB
PzS4Pq0R0AEmqUYEAAAAACapRgQAAAAAAQAAAAkAAAAAAAAABQAAAAAAAAB9IAIABQkAAO0B
AAAAAAAABQAAAAAAAAAuAC4AAAAAAGwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAD80uD6tEdAB
lP7rY5cR0AFCuCwplhHQAVV8VAQAAAAAVXxUBAAAAAAAAAAACQAAAAAAAAAFAAAAAAAAAAhA
mQMFCQAApAEAAAAAAAABAAAAAAAAAAAA/AEAAA==
--------------060302090406040606010809--
