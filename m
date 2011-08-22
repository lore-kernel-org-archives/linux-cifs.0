From: =?UTF-8?B?VGlsbCBEw7ZyZ2Vz?= <doerges-/hMagybUd5GoYr4blSSd5g@public.gmane.org>
Subject: Re: [Samba] mount.cifs with "sec=ntlmv2" fails ("mount error(22):
 Invalid argument")
Date: Mon, 22 Aug 2011 19:01:10 +0200
Message-ID: <4E528B56.5070301@pre-sense.de>
References: <4E527F5C.1090205@pre-sense.de> <CADT32eKLjbuUjY1=PS9Pqa5zWnHNcCcouzPHmTo3s+QO-9iQ4A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000904030605040209010403"
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADT32eKLjbuUjY1=PS9Pqa5zWnHNcCcouzPHmTo3s+QO-9iQ4A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------000904030605040209010403
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hello,

On 22.08.2011 18:28, Shirish Pargaonkar wrote:
> On Mon, Aug 22, 2011 at 11:10 AM, Till Dörges <doerges-/hMagybUd5GoYr4blSSd5g@public.gmane.org> wrote:
>
>> Hello, everyone,
>>
>> I'm trying to mount a CIFS share served by Samba using mount.cifs with NTLMv2
>> authentication.
>>
>>
>> According to 'man mount.cifs' the option "sec=ntlmv2" should be supported, but it
>> keeps giving me "mount error(22): Invalid argument".
>>
>> The Samba server enforces the use of NTLMv2. When allowing for NTLMv1 on both sides
>> everything works just fine.
>>
>>
>> The client runs kernel 2.6.37.6-0.7-desktop (fully patched openSUSE-11.4) with the
>> CIFS kernel module version 1.68. mount.cifs identifies as "version: 4.6".
>>
>>
>> Mounting on the client side it looks like this:
>>
>> --- snip ---
>> #  mount.cifs //abctest.box/abclaufwerk /mnt/mnt/ --verbose -o
>> domain=ABCTEST,user=abc,pass=secrect,sec=ntlmv2
>>
>> mount.cifs kernel mount options:
>> ip=10.9.0.103,unc=\\abctest.box\abclaufwerk,sec=ntlmv2,ver=1,user=abc,domain=ABCTEST,pass=********
>> mount error(22): Invalid argument
>> Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)
>> --- snap ---
>>
>> CIFS debugging on the client is enabled:
>>
>> --- snip ---
>> #  cat /proc/fs/cifs/cifsFYI
>> 1
>> --- snap ---
>>
>> Which yields the following lines in syslog (for the full log see attachment)
>>
>> --- snip ---
>> Aug 22 17:47:34 client kernel: [28966.056081]
>> /usr/src/packages/BUILD/kernel-desktop-2.6.37.6/linux-2.6.37/fs/cifs/connect.c:
>> Security Mode: 0x3 Capabilities: 0x80f3fd TimeAdjust: -7200
>> Aug 22 17:47:34 client kernel: [28966.056088]
>> /usr/src/packages/BUILD/kernel-desktop-2.6.37.6/linux-2.6.37/fs/cifs/sess.c: sess
>> setup type 2
>> --- snap ---
>>
>> "sess setup type 2" seems to indicate that NTLMv2 is used.
>>
>>
>> The server is running a fully patched openSUSE 11.3 with kernel 2.6.34.8-0.2-default
>> and Samba 3.5.4. Both "lanman auth" and "ntlm auth" are disabled, which should force
>> the use of NTLMv2 according to 'man smb.conf':
>>
>> --- snip ---
>> server # testparm 2> /dev/null | egrep 'ntlm|lan'
>>        ntlm auth = No
>> server #
>> --- snap ---
>>
>> The server's corresponding log entries are also attached.
>>
>>
>> Like said above, when I allow for the use of NTLMv1 on both sides (ntlm auth = Yes on
>> the server and no sec=ntlmv2 on the client) everything works just fine.
>>
>> When I enforce NTLMv2 on the server and don't specify "sec=ntlmv2" with mount.cifs I
>> get "mount error(13): Permission denied" and syslog on the client shows that NTLMv1
>> is tried ("sess setup type 1").
>>
>>
>> So is there anything wrong with my setup? Should NTLMv2 be working between Samba and
>> mount.cifs? If it should, why isn't it in this particular setup?
>>
>>
>> Any hints will be greatly appreciated.
>>
>>
>> TIA -- Till

[...]

> sec=ntlmv2 auth type should work between cifs vfs client and Samba server.

Ack.

> Can you try sec=ntlmssp and see if it works?

Yes, that works.
I see "sess setup type 3" in my syslog on the client, and "ntlm_password_check:
Checking NTLMv2 password with domain [***]" on the server. I can sucessfully create
and remove files on the server from the client.

> Can you list the smb.conf file here?

See attachment.

> And a wireshark trace when sec=ntlmv2 fails would be really helpful.

See attachment.

HTH -- Till
-- 
Dipl.-Inform. Till Dörges                  doerges-/hMagybUd5GoYr4blSSd5g@public.gmane.org
                                  Tel. +49 - 40 - 244 2407 - 14
                                  Fax  +49 - 40 - 244 2407 - 24
PRESENSE Technologies GmbH            Sachsenstr. 5, D-20097 HH
                                         USt-IdNr.: DE263765024
Geschäftsführer/Managing Directors       AG Hamburg, HRB 107844
Till Dörges           Jürgen Sander              Axel Theilmann

--------------000904030605040209010403
Content-Type: text/plain;
 name="smb.conf"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="smb.conf"

IyBzZXJ2ZXIgIyBlZ3JlcCAtdiBeIyAvZXRjL3NhbWJhL3NtYi5jb25mCltnbG9iYWxdCiAg
ICAgICAgd29ya2dyb3VwID0gV0RTVEVTVAogICAgICAgIHBhc3NkYiBiYWNrZW5kID0gdGRi
c2FtCiAgICAgICAgbWFwIHRvIGd1ZXN0ID0gQmFkIFVzZXIKICAgICAgICBndWVzdCBhY2Nv
dW50ID0gd2RzZ3Vlc3QKICAgICAgICBsb2dvbiBwYXRoID0gXFwlTFxwcm9maWxlc1wubXNw
cm9maWxlCiAgICAgICAgbG9nb24gaG9tZSA9IFxcJUxcJVVcLjl4cHJvZmlsZQogICAgICAg
IGxvZ29uIGRyaXZlID0gUDoKICAgICAgICB1c2Vyc2hhcmUgYWxsb3cgZ3Vlc3RzID0gWWVz
CiAgICAgICAgYWRkIG1hY2hpbmUgc2NyaXB0ID0gL3Vzci9zYmluL3VzZXJhZGQgIC1jIE1h
Y2hpbmUgLWQgL3Zhci9saWIvbm9ib2R5IC1zIC9iaW4vZmFsc2UgJW0kCiAgICAgICAgZG9t
YWluIGxvZ29ucyA9IFllcwogICAgICAgIGRvbWFpbiBtYXN0ZXIgPSBZZXMKICAgICAgICBs
b2NhbCBtYXN0ZXIgPSBZZXMKICAgICAgICBuZXRiaW9zIG5hbWUgPSBXRFNTQU1CQQogICAg
ICAgIG9zIGxldmVsID0gNjUKICAgICAgICBwcmVmZXJyZWQgbWFzdGVyID0gWWVzCgogICAg
ICAgIHNlY3VyaXR5ID0gdXNlcgogICAgICAgIGxhbm1hbiBhdXRoID0gbm8KICAgICAgICBu
dGxtIGF1dGggPSBubwoKICAgICAgICB3aW5zIHN1cHBvcnQgPSBZZXMKICAgICAgICBsb2cg
bGV2ZWwgPSAxMAoKW2dhc3RsYXVmd2Vya10KICAgICAgICBjb21tZW50ID0gWnVncmlmZiBm
dWVyIEdhZXN0ZQogICAgICAgIGluaGVyaXQgYWNscyA9IFllcwogICAgICAgIHBhdGggPSAv
c3J2L3NhbWJhL2d1ZXN0c2hhcmUKICAgICAgICByZWFkIG9ubHkgPSBObwogICAgICAgIGd1
ZXN0IG9rID0geWVzCiAgICAgICAgZ3Vlc3Qgb25seSA9IHllcwoKW3dkc2xhdWZ3ZXJrXQog
ICAgICAgIGNvbW1lbnQgPSBTaGFyZSBmdWVyIE51dHplciAnd2RzJwogICAgICAgIGluaGVy
aXQgYWNscyA9IFllcwogICAgICAgIHBhdGggPSAvc3J2L3NhbWJhL3dkc3NoYXJlCiAgICAg
ICAgcmVhZCBvbmx5ID0gTm8KICAgICAgICBndWVzdCBvayA9IG5vCiAgICAgICAgdmFsaWQg
dXNlcnMgPSB3ZHMK
--------------000904030605040209010403
Content-Type: application/octet-stream;
 name="ntlmv2-mount-failure.pcap"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="ntlmv2-mount-failure.pcap"

1MOyoQIABAAAAAAAAAAAAP//AAABAAAAEopSTneoBgBKAAAASgAAAOwwkXmkwQAcJZwkGggA
RQAAPNpMQABABpOrwKgBrAoJAGeGHAG9h/0DiQAAAACgAhEczPIAAAIEBbQEAggKAfPZxQAA
AAABAwMHEopSTmqqBgBKAAAASgAAAAAcJZwkGuwwkXmkwQgARQAAPAAAQAA/Bm74CgkAZ8Co
AawBvYYcJBQRz4f9A4qgEhagGtoAAAIEBbQEAggKRwDdtQHz2cUBAwMGEopSTp+qBgBCAAAA
QgAAAOwwkXmkwQAcJZwkGggARQAANNpNQABABpOywKgBrAoJAGeGHAG9h/0DiiQUEdCAEAAj
zOoAAAEBCAoB89nGRwDdtRKKUk7ZrAYAlAAAAJQAAADsMJF5pMEAHCWcJBoIAEUAAIbaTkAA
QAaTX8CoAawKCQBnhhwBvYf9A4okFBHQgBgAI808AAABAQgKAfPZxkcA3bUAAABO/1NNQnIA
AAAAAAHAAAAAAAAAAAAAAAAAAAAfYgAAAQAAKwACTE0xLjJYMDAyAAJMQU5NQU4yLjEAAk5U
IExNIDAuMTIAAlBPU0lYIDIAEopSTnWuBgBCAAAAQgAAAAAcJZwkGuwwkXmkwQgARQAANMxl
QAA/BqKaCgkAZ8CoAawBvYYcJBQR0If9A9yAEABbX5cAAAEBCApHAN21AfPZxhKKUk7uzQYA
owAAAKMAAAAAHCWcJBrsMJF5pMEIAEUAAJXMZkAAPwaiOAoJAGfAqAGsAb2GHCQUEdCH/QPc
gBgAWyc7AAABAQgKRwDdtwHz2cYAAABd/1NNQnIAAAAAgAPAAAAAAAAAAAAAAAAAAAAfYgAA
AQARAgADMgABAARBAAAAAAEAmx0AAP3zgAAA6OhU7GDMAYj/CAgANAqFFfQKgJJXAEQAUwBU
AEUAUwBUAAAAEopSTkLOBgBCAAAAQgAAAOwwkXmkwQAcJZwkGggARQAANNpPQABABpOwwKgB
rAoJAGeGHAG9h/0D3CQUEjGAEAAjzOoAAAEBCAoB89nPRwDdtxKKUk7rzgYA6gEAAOoBAADs
MJF5pMEAHCWcJBoIAEUAAdzaUEAAQAaSB8CoAawKCQBnhhwBvYf9A9wkFBIxgBgAI86SAAAB
AQgKAfPZz0cA3bcAAAGk/1NNQnMAAAAAAAHQAAAAAAAAAAAAAAAAAAAfYgAAAgAN/wAAAFhA
MgAAAAAAAAAAANQAAAAAANzQgABnAW9hHIrUaps+uhzPI4JDalQBAQAAAAAAABwSXlbsYMwB
GXpRAU3skLIAAAAAAgAOAFcARABTAFQARQBTAFQAAQA2AHcAZABzAHQAZQBzAHQALgBpAG4A
dABlAHIAbgAuAHAAcgBlAC0AcwBlAG4AcwBlAC4AZABlAAQADgBXAEQAUwBUAEUAUwBUAAMA
NgB3AGQAcwB0AGUAcwB0AC4AaQBuAHQAZQByAG4ALgBwAHIAZQAtAHMAZQBuAHMAZQAuAGQA
ZQAHAAgAHBJeVuxgzAEAAAAAAHcAZABzAAAAVwBEAFMAVABFAFMAVAAAAEwAaQBuAHUAeAAg
AHYAZQByAHMAaQBvAG4AIAAyAC4ANgAuADMANwAuADYALQAwAC4ANwAtAGQAZQBzAGsAdABv
AHAAAABDAEkARgBTACAAVgBGAFMAIABDAGwAaQBlAG4AdAAgAGYAbwByACAATABpAG4AdQB4
AAAAEopSThjWBgBpAAAAaQAAAAAcJZwkGuwwkXmkwQgARQAAW8xnQAA/BqJxCgkAZ8CoAawB
vYYcJBQSMYf9BYSAGABst9gAAAEBCApHAN24AfPZzwAAACP/U01Ccw0AAMCAA8AAAAAAAAAA
AAAAAAAAAB9iAAACAAAAABKKUk6CcQcAQgAAAEIAAADsMJF5pMEAHCWcJBoIAEUAADTaUUAA
QAaTrsCoAawKCQBnhhwBvYf9BYQkFBJYgBAAI8zqAAABAQgKAfPZ+UcA3bgSilJOgsEIAEIA
AABCAAAA7DCReaTBABwlnCQaCABFAAA02lJAAEAGk63AqAGsCgkAZ4YcAb2H/QWEJBQSWIAR
ACPM6gAAAQEICgHz2k9HAN24EopSTipTCQBCAAAAQgAAAAAcJZwkGuwwkXmkwQgARQAANMxo
QAA/BqKXCgkAZ8CoAawBvYYcJBQSWIf9BYWAEABsXKAAAAEBCApHAN3hAfPaTxKKUk6wkAkA
QgAAAEIAAAAAHCWcJBrsMJF5pMEIAEUAADTMaUAAPwailgoJAGfAqAGsAb2GHCQUEliH/QWF
gBEAbFycAAABAQgKRwDd5AHz2k8SilJO55AJAEIAAABCAAAA7DCReaTBABwlnCQaCABFAAA0
AABAAEAGbgDAqAGsCgkAZ4YcAb2H/QWFJBQSWYAQACNcsAAAAQEICgHz2oRHAN3k
--------------000904030605040209010403--
