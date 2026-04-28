Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EF2B28640C
	for <linux-cifs@vger.kernel.org>; Tue, 28 Apr 2026 16:19:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777393149; cv=pass; b=Oo0egbD9wLHbG7R+MB5fcDzdOSR6xiDQ0Y5tfkls5Ue/saS/O6l14AmqCXY89GevDNyMWljqtXblFwtwnjVGsQZysDRavAz+oHJIwSPClMy6hVkzn+2Iiy9Kt3GLURmfw4BTlseVb+68NOXR2cFh2wuJzlmMZZErFIp53u9BjOA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777393149; c=relaxed/simple;
	bh=uEApiLMXDTo70di2GEmjVxiEKrPQj+czJJkbbKhO3wQ=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=pojU5JxOZc+nqoVZ2ZQDqf04hQyTb9PAmnQpGlQ8hfnfmc8rjjjGfgAVcOmMnRNvnKT4ZwPLEc4yPjoSmHq874kmX+4K9TqdBxXlRuWljwZ+ARgZ16b4kt8eHtEgyAw1Kw3h6KSJKVIQq+LMKzyqTenMWSt9jovn/fTrsDkHQq4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QGjl6kSi; arc=pass smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QGjl6kSi"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-66b2d49ffb0so14701954a12.3
        for <linux-cifs@vger.kernel.org>; Tue, 28 Apr 2026 09:19:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777393146; cv=none;
        d=google.com; s=arc-20240605;
        b=HUqqkGeC05APOSzxBZk0STggwlm7ZhYYIViP28jWKHASlB6qm6LcE1vo6kfeZFmM8Q
         zYK9t28/dK8v5rQ3TmBGciyb9RQtXrHDNi4YbGvV2BlA1M0DY+vuQkSEcE8XpnYNKkxi
         H9z/kNg21IMY+X6LBNUZJYhVXf1TAqHzA7wxeeSdjsmy93ElM1OxNI1ln1EVfjKdePll
         M+vTXC51qglaXlJurQeEkWR9mHJTtJZn1ITG4fBrowtklRsAPaokV7O25WujoWtdcSZM
         CuQqslR2dyo2Ti7nVJXr339hxHcbrwtFTYfsDwBq0esO/krdCEW+xOxW9emWY5G1ABEJ
         Epkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=iwO1j8a1PpEK4oedOBWCoMi11oNnC7Gi2NiIvSOtw28=;
        fh=WW8E9M98PShVPrq5/ST3pV9H8mH84upG0/FNE8xll2Q=;
        b=EaIY7LZuLArow0LgaXpkXENcgpoxEUJBggP69YMXtG55wla4BsiXJc48htei1rIJNA
         65Q+8cNaxlmcTFNBReffLr27pPZZK256nm9xlPoe2TTai+39sNkXONhTztP9gaJJSHbq
         97cFJ3I5p0XrS7l9MN2+ASuL3tIpSIl/50m9vzJ2nExXHN1+KaZvruJtc3pM/45bNNnX
         EPIaTWK7NSvypfXKWwFPujlUK8LwoxG1qotDPMODTt+yzVGeh+iCIapDBcU11SpTTVRh
         sIrlulaokg17Z1yqErpZ45fITe5len9+QG49Hne9PkZ+wG4VO8QcHILbbsNz2cOT8ewR
         2XzA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777393146; x=1777997946; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=iwO1j8a1PpEK4oedOBWCoMi11oNnC7Gi2NiIvSOtw28=;
        b=QGjl6kSic5KA++G+9xrn1jew9v0f55DIdVew51cIaPrdYQEEhHKR5ANZiO/84XImz1
         eUlSjbljJ95btZahdmHGKLJ6yuydQ6qeTxDGTa7LOYc6rFbn7DFNhKcAvmEyAXwO/+xR
         qPgKUQwbqj67zggv7ZXDJidO59+ngsJRrv3gFiUh03SQ2yJ7amV0Keb+Yd2BNmmNOwvn
         lqVym/gCAEw//Go91mmpvdKlPmmxOT7q0ogT8Q45ODdpVw90+3IC8n5S14hztUxiNrjP
         nfO/+dv4n9QndiCtKDdvGiyR4NUBEtDqtO/WM2CfsUKFuRWnuaQqoQs+vGsfXGQELeOM
         rZ3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777393146; x=1777997946;
        h=to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iwO1j8a1PpEK4oedOBWCoMi11oNnC7Gi2NiIvSOtw28=;
        b=iustZvviQFllYzMiksX/eqHdS+jm73uM6W1J41Xnh7sfUeYRSfLopXeykcJPlX4kvP
         3WeWQKo5jIBWsVj/GZZ8snNnKBS0OSY5s9EMHNC97mjJADID7i6kwtlnZLaSReNY/XvH
         1nnxIgLkzc0APbXsj4drbDDTCnrzhB2x6ie6BHL8btryx9m7VbbSyuwTiDVCifHRJ+6a
         3jjl1mB8ZNc6JSo1+buM0AMg76j8uXwyMOVFq6CIbbKmLMA5RwX2CNrSA6qvbvduNjxr
         epRHhzY1SAWAzGcTt52S/U2ilQRELaVtTAE5tQYwzoMN3Om+Vo9ALTHDODwB8tggxW+R
         OFtQ==
X-Gm-Message-State: AOJu0YwpvUC1nUvgEDvglT4hiDHFuhLyGCubfMRe78px74YiBz/cE5XA
	lTtbkRgSjHmrrl4MGvTuW7BQMoCwd+GMmDiOmaqQ2jyZFyQsPmQpS7JTb+/1dJkqRQDU2vxG0RB
	S3iMXlTwPQyczTeOkworeefEe1JqALw/ryfhnnJB5RA==
X-Gm-Gg: AeBDieu5wohx7OfXionx3GTMgFgb9BLO0qunVQUmkiND9kdwv2zQ1h3SHwsYdwPX5LP
	6d/PcULWqGHSxWAGcFZ67OoMl8g1nL23q+xuJhp7+8otQn+JE7zQDmF03bhQXWGqYIHd8Kw+CkT
	NXQs7kUt1trw5rDCyvubkoBvoPhoaUeldXdFknKYLwzxiKZ7pU9iLEB2EeYkY2dhVIAEHaxCSPQ
	jtJHr50ZtmyIF6KTHdNzcF8tK8gSwfXUbfvzHkrWqZyZ89vbYQ97z1P8bGOfrpSWpj38jDtVw9g
	S+MLwM2ROnPgZpVy
X-Received: by 2002:a17:907:e107:b0:ba3:99:29d0 with SMTP id
 a640c23a62f3a-bb801ed597fmr159423766b.18.1777393145968; Tue, 28 Apr 2026
 09:19:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Tue, 28 Apr 2026 21:48:52 +0530
X-Gm-Features: AVHnY4LOKxK1WTy1ScU-9eOov_i_h59KZ4Fs4N2XY7Taqx8XfPWxEMuGtsoT6L0
Message-ID: <CANT5p=pTSh=R7mj6gc=70YZ9fdahYYUT5E2tdxwxZJ=jOrKCjQ@mail.gmail.com>
Subject: [PATCHSET v3] QueryDir and Directory lease improvements
To: CIFS <linux-cifs@vger.kernel.org>, Steve French <smfrench@gmail.com>, 
	Bharath SM <bharathsm.hsk@gmail.com>, David Howells <dhowells@redhat.com>, 
	Enzo Matsumiya <ematsumiya@suse.de>, Henrique Carvalho <henrique.carvalho@suse.com>, 
	Paulo Alcantara <pc@manguebit.org>
Content-Type: multipart/mixed; boundary="00000000000017c3c0065087971b"

--00000000000017c3c0065087971b
Content-Type: text/plain; charset="UTF-8"

Hi folks,

This patch set of 19 patches is meant to improve metadata performance
mainly surrounding readdir scenario, both with and without directory
leases.

Here is a list of fixes/features:
https://github.com/sprasad-microsoft/smb3-kernel-client/compare/master...personal/sprasad/for-next
 cifs: change_conf needs to be called for session setup -> This bug
could cause the client not to request for lease if readdir is run
immediately following mount and multichannel is enabled
 cifs: abort open_cached_dir if we don't request leases -> This bug
can cause an extra round-trip that can be avoided
 cifs: invalidate cfid on unlink/rename/rmdir -> This is a serious bug
that can cause stale dir enumeration following an unlink/rename/rmdir
 cifs: define variable sized buffer for querydir responses -> Enables
the next set of changes by allowing QueryDir responses to be larger
than 64KB
 cifs: optimize readdir for small directories -> Similar to Windows
client, the Linux client will now send Open+QueryDir1+QueryDir2 in a
single compound request, avoiding an extra round-trip for all small
directories
 cifs: optimize readdir for larger directories -> For directories that
need a second round-trip, with this change, we'll now request for
rsize QueryDir responses
 cifs: reorganize cached dir helpers -> Cosmetic change. For better readability
 cifs: make cfid locks more granular -> With parallel readdirs and dir
lease enabled, the client will now serialize operations under a big
chunky lock. This change introduces finer locks for better
parallelization
 cifs: query dir should reuse cfid even if not fully cached -> Avoids
unnecessary breaking of dir leases when parallel readdirs to same
directory are happening
 cifs: back cached_dirents with page cache -> Significant
re-architecture of dir cache code to enable faster lookups and reduced
allocations for large directories
 cifs: in place changes to cached_dirents when dir lease is held ->
With this change, the client does not revoke dir lease when the
directory is changed anymore
 cifs: register a shrinker to manage cached_dirents -> This change
allows the kernel to callback to the SMB client to free up dir cache
under memory pressure
 cifs: option to disable time-based eviction of cache -> With the last
change, the client can now hold leases for a really long time
 cifs: option to set unlimited number of cached dirs -> With shrinker
registered, the client can now cache a really large number of dirs.
Helpful for workloads that contain a large number of small dirs
 cifs: allow dcache population to happen asynchronously ->
Experimental module param to asynchronously populate the dentry cache.
This allows operations like plain directory enumeration (without attr
requests) to complete much faster
 cifs: trace points for cached_dir operations -> Aids debugging of dir
caching code
 cifs: discard functions should not return failure -> This serious but
rare bug can cause hangs in reads and readdirs when specific network
errors are returned
 cifs: keep cfids in rbtree for efficient lookups -> With the ability
to cache large number of dirs, keeping them on a linked list was
becoming a bottleneck. This enables faster lookups of dir cache data
 cifs: invalidate cached_dirents if population aborted -> This allows
dir cache to be invalidated when the application stops continued dir
enumeration

Overall, these changes have significantly improved perf for many
metadata heavy workloads.
Attaching a performance benchmark report for various workloads that I ran.

Overall, not too much penalty for populating the cache with dir leases
enabled (in fact, for some workloads, it improves perf with cold
cache).
With warm cache, we've reduced the server round-trips to a bare
minimum (pretty much only file opens/closes). So with directory leases
enabled, there is significant reduction in the number of round-trips.
I was hoping to improve tar/untar performance. However, they still
involve serialized open/read/close calls to the server that cannot be
avoided even with dir leases.

-- 
Regards,
Shyam

--00000000000017c3c0065087971b
Content-Type: application/octet-stream; 
	name="dirlease-optimizations5-combined-win.md"
Content-Disposition: attachment; 
	filename="dirlease-optimizations5-combined-win.md"
Content-Transfer-Encoding: base64
Content-ID: <f_moitxth50>
X-Attachment-Id: f_moitxth50

IyMgTGVnZW5kCgotIGBsc19yYDogUmVjdXJzaXZlIGRpcmVjdG9yeSBsaXN0aW5nIHVzaW5nIGBs
cyAtUmAgKG5hbWUgZW51bWVyYXRpb24gZm9jdXNlZCkuCi0gYGxzX2xyYDogUmVjdXJzaXZlIGxv
bmcgbGlzdGluZyB1c2luZyBgbHMgLWxSYCAobmFtZSArIGF0dHJpYnV0ZSBtZXRhZGF0YSkuCi0g
YGxzX3RoZW5fbHNsYDogVHdvLXN0ZXAgcnVuIHdoZXJlIGl0ZXJhdGlvbiAxIGlzIGBscyAtUmAg
YW5kIGl0ZXJhdGlvbiAyIGlzIGBscyAtbFJgLgotIGBmaW5kX25vbmVtcHR5YDogRmlsZSB0cmF2
ZXJzYWwgdXNpbmcgYGZpbmQgLXR5cGUgZiAtc2l6ZSArMGNgLiAoZmluZCBhbGwgcmVndWxhciBm
aWxlcyB3aXRoIG5vbi16ZXJvIHNpemUpCi0gYGR1X3JlY3Vyc2l2ZWA6IFJlY3Vyc2l2ZSBkaXNr
IHVzYWdlIHNjYW4gdXNpbmcgYGR1YC4KLSBgQ29sZGA6IEZpcnN0IGl0ZXJhdGlvbiBhZnRlciBy
ZW1vdW50IChjb2xkIGNhY2hlIHN0YXRlKS4KLSBgV2FybWA6IFNlY29uZCBpdGVyYXRpb24gaW1t
ZWRpYXRlbHkgYWZ0ZXIgY29sZCBydW4gKHdhcm0gY2FjaGUgc3RhdGUpLgotIGBmbGF0X2RpcmA6
IEZsYXQgbmFtZXNwYWNlIHdpdGggbGFyZ2UgbnVtYmVyIG9mIGZpbGVzIGluIG9uZSBkaXJlY3Rv
cnkuCi0gYGRlZXBfZGlyYDogRGVlcCBoaWVyYXJjaGljYWwgbmFtZXNwYWNlIHdpdGggbmVzdGVk
IGRpcmVjdG9yaWVzLgotIGBUb3RhbCBUaW1lYDogRW5kLXRvLWVuZCBlbGFwc2VkIHJ1bnRpbWUg
Zm9yIHRoYXQgd29ya2xvYWQvaXRlcmF0aW9uLgotIGBRdWVyeURpcmVjdG9yaWVzYDogU01CMiBk
aXJlY3RvcnkgcXVlcnkgb3BlcmF0aW9ucyBvYnNlcnZlZCBkdXJpbmcgdGhlIHJ1bi4KLSBgUXVl
cnlJbmZvc2A6IFNNQjIgbWV0YWRhdGEgcXVlcnkgb3BlcmF0aW9ucyBvYnNlcnZlZCBkdXJpbmcg
dGhlIHJ1bi4KLSBTaWduIGNvbnZlbnRpb24gaW4gdGFibGVzOiB2YWx1ZXMgYXJlIHNob3duIGFz
IGBiYXNlbGluZSAtPiBjb21wYXJpc29uYDsgbmVnYXRpdmUgYCVgIGluIGBUb3RhbCBUaW1lYCBt
ZWFucyB0aGUgY29tcGFyaXNvbiBydW4gaXMgZmFzdGVyLgoKIyMgU3VtbWFyeQoKKipLZXkgRmlu
ZGluZ3M6KioKCjEuICoqZGlyZWN0b3J5IGxlYXNlIG9wdGltaXphdGlvbnM1IHZzIG1haW5saW5l
OioqCiAgIC0gaGFuZGxlY2FjaGUgLyBmbGF0X2RpciBhdmVyYWdlOiAqKi0yMy43JSoqCiAgIC0g
aGFuZGxlY2FjaGUgLyBkZWVwX2RpciBhdmVyYWdlOiAqKi0zNy42JSoqCiAgIC0gbm9oYW5kbGVj
YWNoZSAvIGZsYXRfZGlyIGF2ZXJhZ2U6ICoqLTEzLjUlKioKICAgLSBub2hhbmRsZWNhY2hlIC8g
ZGVlcF9kaXIgYXZlcmFnZTogKiotMzAuNCUqKgoyLiAqKldpdGhpbiBkaXJlY3RvcnkgbGVhc2Ug
b3B0aW1pemF0aW9uczUgKGhhbmRsZWNhY2hlIHZzIG5vaGFuZGxlY2FjaGUpOioqCiAgIC0gZmxh
dF9kaXI6IGhhbmRsZWNhY2hlIGlzICoqLTE0LjQlKiogdnMgbm9oYW5kbGVjYWNoZSAoYXZnKQog
ICAtIGRlZXBfZGlyOiBoYW5kbGVjYWNoZSBpcyAqKi05LjUlKiogdnMgbm9oYW5kbGVjYWNoZSAo
YXZnKQoKLS0tCgojIyBDb21wYXJpc29uIEE6IGRpcmVjdG9yeSBsZWFzZSBvcHRpbWl6YXRpb25z
NSB2cyBtYWlubGluZQoKIyMjIGhhbmRsZWNhY2hlIC8gZmxhdF9kaXIKCnwgV29ya2xvYWQgfCBJ
dGVyYXRpb24gfCBUb3RhbCBUaW1lIHwgUXVlcnlEaXJlY3RvcmllcyB8IFF1ZXJ5SW5mb3MgfAp8
LS0tfC0tLXwtLS18LS0tfC0tLXwKfCBsc19yIHwgQ29sZCB8IDU4NTEgLT4gNDkyNiAoLTkyNSwg
LTE1LjglKSB8IDczMSAtPiA5ICgtNzIyLCAtOTguOCUpIHwgMSAtPiAyICgrMSwgKzEwMC4wJSkg
fAp8IGxzX3IgfCBXYXJtIHwgMTA3NiAtPiAxMDggKC05NjgsIC05MC4wJSkgfCA3MzEgLT4gMCAo
LTczMSwgLTEwMC4wJSkgfCAwIC0+IDAgfAp8IGxzX2xyIHwgQ29sZCB8IDg3OTAgLT4gNzgxMiAo
LTk3OCwgLTExLjElKSB8IDczMSAtPiA5ICgtNzIyLCAtOTguOCUpIHwgMSAtPiAyICgrMSwgKzEw
MC4wJSkgfAp8IGxzX2xyIHwgV2FybSB8IDM5NDYgLT4gMzA4OSAoLTg1NywgLTIxLjclKSB8IDcz
MSAtPiAwICgtNzMxLCAtMTAwLjAlKSB8IDAgLT4gMCB8CnwgbHNfdGhlbl9sc2wgfCBDb2xkIHwg
NTg0NSAtPiA0OTY4ICgtODc3LCAtMTUuMCUpIHwgNzMxIC0+IDkgKC03MjIsIC05OC44JSkgfCAx
IC0+IDIgKCsxLCArMTAwLjAlKSB8CnwgbHNfdGhlbl9sc2wgfCBXYXJtIHwgMzg4NiAtPiAzMDg5
ICgtNzk3LCAtMjAuNSUpIHwgNzMxIC0+IDAgKC03MzEsIC0xMDAuMCUpIHwgMCAtPiAwIHwKfCBm
aW5kX25vbmVtcHR5IHwgQ29sZCB8IDg1MDEgLT4gNzYzNiAoLTg2NSwgLTEwLjIlKSB8IDczMSAt
PiA5ICgtNzIyLCAtOTguOCUpIHwgMiAtPiAzICgrMSwgKzUwLjAlKSB8CnwgZmluZF9ub25lbXB0
eSB8IFdhcm0gfCAzNjg5IC0+IDI4NjUgKC04MjQsIC0yMi4zJSkgfCA3MzEgLT4gMCAoLTczMSwg
LTEwMC4wJSkgfCAxIC0+IDEgKCswLCArMC4wJSkgfAp8IGR1X3JlY3Vyc2l2ZSB8IENvbGQgfCA4
MzIyIC0+IDc2MTMgKC03MDksIC04LjUlKSB8IDczMSAtPiA5ICgtNzIyLCAtOTguOCUpIHwgMiAt
PiAzICgrMSwgKzUwLjAlKSB8CnwgZHVfcmVjdXJzaXZlIHwgV2FybSB8IDM1MTYgLT4gMjc0OSAo
LTc2NywgLTIxLjglKSB8IDczMSAtPiAwICgtNzMxLCAtMTAwLjAlKSB8IDEgLT4gMSAoKzAsICsw
LjAlKSB8CgojIyMgaGFuZGxlY2FjaGUgLyBkZWVwX2RpcgoKfCBXb3JrbG9hZCB8IEl0ZXJhdGlv
biB8IFRvdGFsIFRpbWUgfCBRdWVyeURpcmVjdG9yaWVzIHwgUXVlcnlJbmZvcyB8CnwtLS18LS0t
fC0tLXwtLS18LS0tfAp8IGxzX3IgfCBDb2xkIHwgMzk0MTkgLT4gMzkwMDAgKC00MTksIC0xLjEl
KSB8IDMwMDEwIC0+IDMwMDEwICgrMCwgKzAuMCUpIHwgMyAtPiAxNTAwNyAoKzE1MDA0LCArNTAw
MTMzLjMlKSB8CnwgbHNfciB8IFdhcm0gfCAzMzU0OSAtPiA0ODU1ICgtMjg2OTQsIC04NS41JSkg
fCAzMDAxMCAtPiAwICgtMzAwMTAsIC0xMDAuMCUpIHwgMiAtPiAwICgtMiwgLTEwMC4wJSkgfAp8
IGxzX2xyIHwgQ29sZCB8IDQzODQ5IC0+IDQ0NjU3ICgrODA4LCArMS44JSkgfCAzMDAxMCAtPiAz
MDAxMCAoKzAsICswLjAlKSB8IDMgLT4gMTUwMDcgKCsxNTAwNCwgKzUwMDEzMy4zJSkgfAp8IGxz
X2xyIHwgV2FybSB8IDM4MDM1IC0+IDExMjEzICgtMjY4MjIsIC03MC41JSkgfCAzMDAxMCAtPiAw
ICgtMzAwMTAsIC0xMDAuMCUpIHwgMiAtPiAwICgtMiwgLTEwMC4wJSkgfAp8IGxzX3RoZW5fbHNs
IHwgQ29sZCB8IDM3Nzg2IC0+IDM4ODI0ICgrMTAzOCwgKzIuNyUpIHwgMzAwMTAgLT4gMzAwMTAg
KCswLCArMC4wJSkgfCAzIC0+IDE1MDA3ICgrMTUwMDQsICs1MDAxMzMuMyUpIHwKfCBsc190aGVu
X2xzbCB8IFdhcm0gfCAzNjU5MiAtPiAxMTU5NyAoLTI0OTk1LCAtNjguMyUpIHwgMzAwMTAgLT4g
MCAoLTMwMDEwLCAtMTAwLjAlKSB8IDIgLT4gMCAoLTIsIC0xMDAuMCUpIHwKfCBmaW5kX25vbmVt
cHR5IHwgQ29sZCB8IDQyNjkxIC0+IDQzMjg0ICgrNTkzLCArMS40JSkgfCAzMDAxMCAtPiAzMDAx
MCAoKzAsICswLjAlKSB8IDQgLT4gMTUwMDggKCsxNTAwNCwgKzM3NTEwMC4wJSkgfAp8IGZpbmRf
bm9uZW1wdHkgfCBXYXJtIHwgMzY3MzMgLT4gODYwMyAoLTI4MTMwLCAtNzYuNiUpIHwgMzAwMTAg
LT4gMCAoLTMwMDEwLCAtMTAwLjAlKSB8IDMgLT4gMSAoLTIsIC02Ni43JSkgfAp8IGR1X3JlY3Vy
c2l2ZSB8IENvbGQgfCA0MjMwNyAtPiA0MzMwNSAoKzk5OCwgKzIuNCUpIHwgMzAwMTAgLT4gMzAw
MTAgKCswLCArMC4wJSkgfCA0IC0+IDE1MDA4ICgrMTUwMDQsICszNzUxMDAuMCUpIHwKfCBkdV9y
ZWN1cnNpdmUgfCBXYXJtIHwgNDkzNTYgLT4gODg2NiAoLTQwNDkwLCAtODIuMCUpIHwgMzAwMTAg
LT4gMCAoLTMwMDEwLCAtMTAwLjAlKSB8IDUgLT4gMSAoLTQsIC04MC4wJSkgfAoKIyMjIG5vaGFu
ZGxlY2FjaGUgLyBmbGF0X2RpcgoKfCBXb3JrbG9hZCB8IEl0ZXJhdGlvbiB8IFRvdGFsIFRpbWUg
fCBRdWVyeURpcmVjdG9yaWVzIHwgUXVlcnlJbmZvcyB8CnwtLS18LS0tfC0tLXwtLS18LS0tfAp8
IGxzX3IgfCBDb2xkIHwgNTgwNiAtPiA1MjUwICgtNTU2LCAtOS42JSkgfCA3MzEgLT4gOSAoLTcy
MiwgLTk4LjglKSB8IDEgLT4gMSAoKzAsICswLjAlKSB8CnwgbHNfciB8IFdhcm0gfCAxMDk1IC0+
IDU5MiAoLTUwMywgLTQ1LjklKSB8IDczMSAtPiA5ICgtNzIyLCAtOTguOCUpIHwgMCAtPiAwIHwK
fCBsc19sciB8IENvbGQgfCA4NjYyIC0+IDgxMDUgKC01NTcsIC02LjQlKSB8IDczMSAtPiA5ICgt
NzIyLCAtOTguOCUpIHwgMSAtPiAxICgrMCwgKzAuMCUpIHwKfCBsc19sciB8IFdhcm0gfCAzOTM4
IC0+IDM0NzggKC00NjAsIC0xMS43JSkgfCA3MzEgLT4gOSAoLTcyMiwgLTk4LjglKSB8IDAgLT4g
MCB8CnwgbHNfdGhlbl9sc2wgfCBDb2xkIHwgNTg1NSAtPiA1MTgwICgtNjc1LCAtMTEuNSUpIHwg
NzMxIC0+IDkgKC03MjIsIC05OC44JSkgfCAxIC0+IDEgKCswLCArMC4wJSkgfAp8IGxzX3RoZW5f
bHNsIHwgV2FybSB8IDM5MDEgLT4gMzQ5MSAoLTQxMCwgLTEwLjUlKSB8IDczMSAtPiA5ICgtNzIy
LCAtOTguOCUpIHwgMCAtPiAwIHwKfCBmaW5kX25vbmVtcHR5IHwgQ29sZCB8IDg0NjMgLT4gNzkz
NSAoLTUyOCwgLTYuMiUpIHwgNzMxIC0+IDkgKC03MjIsIC05OC44JSkgfCAyIC0+IDIgKCswLCAr
MC4wJSkgfAp8IGZpbmRfbm9uZW1wdHkgfCBXYXJtIHwgMzY4NCAtPiAzMjIxICgtNDYzLCAtMTIu
NiUpIHwgNzMxIC0+IDkgKC03MjIsIC05OC44JSkgfCAxIC0+IDEgKCswLCArMC4wJSkgfAp8IGR1
X3JlY3Vyc2l2ZSB8IENvbGQgfCA4MzIzIC0+IDc2ODcgKC02MzYsIC03LjYlKSB8IDczMSAtPiA5
ICgtNzIyLCAtOTguOCUpIHwgMiAtPiAyICgrMCwgKzAuMCUpIHwKfCBkdV9yZWN1cnNpdmUgfCBX
YXJtIHwgMzQ5NSAtPiAzMDUwICgtNDQ1LCAtMTIuNyUpIHwgNzMxIC0+IDkgKC03MjIsIC05OC44
JSkgfCAxIC0+IDEgKCswLCArMC4wJSkgfAoKIyMjIG5vaGFuZGxlY2FjaGUgLyBkZWVwX2RpcgoK
fCBXb3JrbG9hZCB8IEl0ZXJhdGlvbiB8IFRvdGFsIFRpbWUgfCBRdWVyeURpcmVjdG9yaWVzIHwg
UXVlcnlJbmZvcyB8CnwtLS18LS0tfC0tLXwtLS18LS0tfAp8IGxzX3IgfCBDb2xkIHwgNDQ2Mjkg
LT4gMjQ5NDEgKC0xOTY4OCwgLTQ0LjElKSB8IDMwMDEwIC0+IDMwMDEwICgrMCwgKzAuMCUpIHwg
NSAtPiAyICgtMywgLTYwLjAlKSB8CnwgbHNfciB8IFdhcm0gfCAzMjY5MyAtPiAxOTE0NiAoLTEz
NTQ3LCAtNDEuNCUpIHwgMzAwMTAgLT4gMzAwMTAgKCswLCArMC4wJSkgfCAyIC0+IDEgKC0xLCAt
NTAuMCUpIHwKfCBsc19sciB8IENvbGQgfCA0NDIzMCAtPiAyOTYxMyAoLTE0NjE3LCAtMzMuMCUp
IHwgMzAwMTAgLT4gMzAwMTAgKCswLCArMC4wJSkgfCA0IC0+IDEgKC0zLCAtNzUuMCUpIHwKfCBs
c19sciB8IFdhcm0gfCAzODIxNyAtPiAyMzc3OSAoLTE0NDM4LCAtMzcuOCUpIHwgMzAwMTAgLT4g
MzAwMTAgKCswLCArMC4wJSkgfCAyIC0+IDEgKC0xLCAtNTAuMCUpIHwKfCBsc190aGVuX2xzbCB8
IENvbGQgfCAzODQ1NSAtPiAyNTMyNiAoLTEzMTI5LCAtMzQuMSUpIHwgMzAwMTAgLT4gMzAwMTAg
KCswLCArMC4wJSkgfCAzIC0+IDEgKC0yLCAtNjYuNyUpIHwKfCBsc190aGVuX2xzbCB8IFdhcm0g
fCAzNzExOCAtPiAyNDEwMCAoLTEzMDE4LCAtMzUuMSUpIHwgMzAwMTAgLT4gMzAwMTAgKCswLCAr
MC4wJSkgfCAyIC0+IDEgKC0xLCAtNTAuMCUpIHwKfCBmaW5kX25vbmVtcHR5IHwgQ29sZCB8IDQy
MTk0IC0+IDM4NDk0ICgtMzcwMCwgLTguOCUpIHwgMzAwMTAgLT4gMzAwMTAgKCswLCArMC4wJSkg
fCA0IC0+IDQgKCswLCArMC4wJSkgfAp8IGZpbmRfbm9uZW1wdHkgfCBXYXJtIHwgMzY0MzEgLT4g
MzY0OTUgKCs2NCwgKzAuMiUpIHwgMzAwMTAgLT4gMzAwMTAgKCswLCArMC4wJSkgfCAzIC0+IDMg
KCswLCArMC4wJSkgfAp8IGR1X3JlY3Vyc2l2ZSB8IENvbGQgfCA0Mjc4MSAtPiAyODkzMiAoLTEz
ODQ5LCAtMzIuNCUpIHwgMzAwMTAgLT4gMzAwMTAgKCswLCArMC4wJSkgfCA0IC0+IDIgKC0yLCAt
NTAuMCUpIHwKfCBkdV9yZWN1cnNpdmUgfCBXYXJtIHwgMzY5NTMgLT4gMjMyOTcgKC0xMzY1Niwg
LTM3LjAlKSB8IDMwMDEwIC0+IDMwMDEwICgrMCwgKzAuMCUpIHwgMyAtPiAyICgtMSwgLTMzLjMl
KSB8CgotLS0KCiMjIENvbXBhcmlzb24gQjogaGFuZGxlY2FjaGUgdnMgbm9oYW5kbGVjYWNoZSAo
d2l0aGluIGRpcmVjdG9yeSBsZWFzZSBvcHRpbWl6YXRpb25zNSkKCiMjIyBmbGF0X2RpciAobm9o
YW5kbGVjYWNoZSB2cyBoYW5kbGVjYWNoZSkKCnwgV29ya2xvYWQgfCBJdGVyYXRpb24gfCBUb3Rh
bCBUaW1lIHwgUXVlcnlEaXJlY3RvcmllcyB8IFF1ZXJ5SW5mb3MgfAp8LS0tfC0tLXwtLS18LS0t
fC0tLXwKfCBsc19yIHwgQ29sZCB8IDUyNTAgLT4gNDkyNiAoLTMyNCwgLTYuMiUpIHwgOSAtPiA5
ICgrMCwgKzAuMCUpIHwgMSAtPiAyICgrMSwgKzEwMC4wJSkgfAp8IGxzX3IgfCBXYXJtIHwgNTky
IC0+IDEwOCAoLTQ4NCwgLTgxLjglKSB8IDkgLT4gMCAoLTksIC0xMDAuMCUpIHwgMCAtPiAwIHwK
fCBsc19sciB8IENvbGQgfCA4MTA1IC0+IDc4MTIgKC0yOTMsIC0zLjYlKSB8IDkgLT4gOSAoKzAs
ICswLjAlKSB8IDEgLT4gMiAoKzEsICsxMDAuMCUpIHwKfCBsc19sciB8IFdhcm0gfCAzNDc4IC0+
IDMwODkgKC0zODksIC0xMS4yJSkgfCA5IC0+IDAgKC05LCAtMTAwLjAlKSB8IDAgLT4gMCB8Cnwg
bHNfdGhlbl9sc2wgfCBDb2xkIHwgNTE4MCAtPiA0OTY4ICgtMjEyLCAtNC4xJSkgfCA5IC0+IDkg
KCswLCArMC4wJSkgfCAxIC0+IDIgKCsxLCArMTAwLjAlKSB8CnwgbHNfdGhlbl9sc2wgfCBXYXJt
IHwgMzQ5MSAtPiAzMDg5ICgtNDAyLCAtMTEuNSUpIHwgOSAtPiAwICgtOSwgLTEwMC4wJSkgfCAw
IC0+IDAgfAp8IGZpbmRfbm9uZW1wdHkgfCBDb2xkIHwgNzkzNSAtPiA3NjM2ICgtMjk5LCAtMy44
JSkgfCA5IC0+IDkgKCswLCArMC4wJSkgfCAyIC0+IDMgKCsxLCArNTAuMCUpIHwKfCBmaW5kX25v
bmVtcHR5IHwgV2FybSB8IDMyMjEgLT4gMjg2NSAoLTM1NiwgLTExLjElKSB8IDkgLT4gMCAoLTks
IC0xMDAuMCUpIHwgMSAtPiAxICgrMCwgKzAuMCUpIHwKfCBkdV9yZWN1cnNpdmUgfCBDb2xkIHwg
NzY4NyAtPiA3NjEzICgtNzQsIC0xLjAlKSB8IDkgLT4gOSAoKzAsICswLjAlKSB8IDIgLT4gMyAo
KzEsICs1MC4wJSkgfAp8IGR1X3JlY3Vyc2l2ZSB8IFdhcm0gfCAzMDUwIC0+IDI3NDkgKC0zMDEs
IC05LjklKSB8IDkgLT4gMCAoLTksIC0xMDAuMCUpIHwgMSAtPiAxICgrMCwgKzAuMCUpIHwKCiMj
IyBkZWVwX2RpciAobm9oYW5kbGVjYWNoZSB2cyBoYW5kbGVjYWNoZSkKCnwgV29ya2xvYWQgfCBJ
dGVyYXRpb24gfCBUb3RhbCBUaW1lIHwgUXVlcnlEaXJlY3RvcmllcyB8IFF1ZXJ5SW5mb3MgfAp8
LS0tfC0tLXwtLS18LS0tfC0tLXwKfCBsc19yIHwgQ29sZCB8IDI0OTQxIC0+IDM5MDAwICgrMTQw
NTksICs1Ni40JSkgfCAzMDAxMCAtPiAzMDAxMCAoKzAsICswLjAlKSB8IDIgLT4gMTUwMDcgKCsx
NTAwNSwgKzc1MDI1MC4wJSkgfAp8IGxzX3IgfCBXYXJtIHwgMTkxNDYgLT4gNDg1NSAoLTE0Mjkx
LCAtNzQuNiUpIHwgMzAwMTAgLT4gMCAoLTMwMDEwLCAtMTAwLjAlKSB8IDEgLT4gMCAoLTEsIC0x
MDAuMCUpIHwKfCBsc19sciB8IENvbGQgfCAyOTYxMyAtPiA0NDY1NyAoKzE1MDQ0LCArNTAuOCUp
IHwgMzAwMTAgLT4gMzAwMTAgKCswLCArMC4wJSkgfCAxIC0+IDE1MDA3ICgrMTUwMDYsICsxNTAw
NjAwLjAlKSB8CnwgbHNfbHIgfCBXYXJtIHwgMjM3NzkgLT4gMTEyMTMgKC0xMjU2NiwgLTUyLjgl
KSB8IDMwMDEwIC0+IDAgKC0zMDAxMCwgLTEwMC4wJSkgfCAxIC0+IDAgKC0xLCAtMTAwLjAlKSB8
CnwgbHNfdGhlbl9sc2wgfCBDb2xkIHwgMjUzMjYgLT4gMzg4MjQgKCsxMzQ5OCwgKzUzLjMlKSB8
IDMwMDEwIC0+IDMwMDEwICgrMCwgKzAuMCUpIHwgMSAtPiAxNTAwNyAoKzE1MDA2LCArMTUwMDYw
MC4wJSkgfAp8IGxzX3RoZW5fbHNsIHwgV2FybSB8IDI0MTAwIC0+IDExNTk3ICgtMTI1MDMsIC01
MS45JSkgfCAzMDAxMCAtPiAwICgtMzAwMTAsIC0xMDAuMCUpIHwgMSAtPiAwICgtMSwgLTEwMC4w
JSkgfAp8IGZpbmRfbm9uZW1wdHkgfCBDb2xkIHwgMzg0OTQgLT4gNDMyODQgKCs0NzkwLCArMTIu
NCUpIHwgMzAwMTAgLT4gMzAwMTAgKCswLCArMC4wJSkgfCA0IC0+IDE1MDA4ICgrMTUwMDQsICsz
NzUxMDAuMCUpIHwKfCBmaW5kX25vbmVtcHR5IHwgV2FybSB8IDM2NDk1IC0+IDg2MDMgKC0yNzg5
MiwgLTc2LjQlKSB8IDMwMDEwIC0+IDAgKC0zMDAxMCwgLTEwMC4wJSkgfCAzIC0+IDEgKC0yLCAt
NjYuNyUpIHwKfCBkdV9yZWN1cnNpdmUgfCBDb2xkIHwgMjg5MzIgLT4gNDMzMDUgKCsxNDM3Mywg
KzQ5LjclKSB8IDMwMDEwIC0+IDMwMDEwICgrMCwgKzAuMCUpIHwgMiAtPiAxNTAwOCAoKzE1MDA2
LCArNzUwMzAwLjAlKSB8CnwgZHVfcmVjdXJzaXZlIHwgV2FybSB8IDIzMjk3IC0+IDg4NjYgKC0x
NDQzMSwgLTYxLjklKSB8IDMwMDEwIC0+IDAgKC0zMDAxMCwgLTEwMC4wJSkgfCAyIC0+IDEgKC0x
LCAtNTAuMCUpIHwKCg==
--00000000000017c3c0065087971b--
