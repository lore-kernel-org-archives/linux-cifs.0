From: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
Subject: NIST SP800-138 availibility using kernel crypto APIs for SMB3.0 MAC generation
Date: Sun, 19 May 2013 21:49:58 -0500
Message-ID: <CADT32eKKeouXxVv57bEfug-Kr89VJ-wfcaxRw_E79g5MLw4_3Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org,
	linux-cifs <linux-cifs@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

With the recent patches added to kernel crypto for improving AES
support, adding aesni etc, it seems like it is time to add AES CMAC
to the cifs kernel module (for the popular SMB3 signing and per-share
encryption) but needed for an implementation for SP800-138 in kernel
crypto codebase.
Was specifically interested using the way defined in 3.1.4.2 of
MS-SMB2 document, in particular

KDF in Counter mode (section 5.1 of NIST SP 800-108) or a way to specify a mode
PRF as HMAC-SHA256 (or a way to specify a PRF)


cifs client would use this algorithm for SMB3.0 MAC generation
(network packet signing on network file system mounts to newer
generation NAS, and Windows 2012) and also for per-share encryption
(which is also available on the most recent generation of NAS via
SMB3). Apparently with current Intel processors having hardware for
this kind of encryption offload - full packet encryption is faster
than packet signing used to be (with the older standard algorithms)
and just doing packet signing is really fast.

Are their APIs in crypto kernel code to use for this purpose?

Regards,

Shirish
