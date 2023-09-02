Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26E69C71153
	for <linux-cifs@archiver.kernel.org>; Sat,  2 Sep 2023 19:11:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbjIBTLU (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 2 Sep 2023 15:11:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232225AbjIBTLT (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 2 Sep 2023 15:11:19 -0400
X-Greylist: delayed 541 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 02 Sep 2023 12:11:15 PDT
Received: from mail.cs.ucla.edu (mail.cs.ucla.edu [131.179.128.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BF0FCC5
        for <linux-cifs@vger.kernel.org>; Sat,  2 Sep 2023 12:11:15 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.cs.ucla.edu (Postfix) with ESMTP id 11EA93C011BDF
        for <linux-cifs@vger.kernel.org>; Sat,  2 Sep 2023 12:02:14 -0700 (PDT)
Received: from mail.cs.ucla.edu ([127.0.0.1])
        by localhost (mail.cs.ucla.edu [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id dcbrHXTFq_tI for <linux-cifs@vger.kernel.org>;
        Sat,  2 Sep 2023 12:02:13 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.cs.ucla.edu (Postfix) with ESMTP id ABE3D3C011BE9
        for <linux-cifs@vger.kernel.org>; Sat,  2 Sep 2023 12:02:13 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.cs.ucla.edu ABE3D3C011BE9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cs.ucla.edu;
        s=9D0B346E-2AEB-11ED-9476-E14B719DCE6C; t=1693681333;
        bh=w6eOJyYwIASsZC/vm2LObMxW3T9Zi90r6hBN5svBrY8=;
        h=Message-ID:Date:MIME-Version:To:From;
        b=U+Zq5a4AFagX998LdSvzOtmpeuV3Skh8yiOK96hiec442iFFwkN5KLNna9hbm9TAD
         feTvOc747rYv/Luhy3ltUWq3WtiQcu28Fj5/YEwzVMkYHj8TxKmM8QKYR18OqLEu1q
         IyR5TAt5PqWpCWQUou4aRLOTM/VLGOtta4gsuLNyDYPlUXBZkhrHUVfzoSGZCq3BT7
         ixHQ0pguCBDlzOdkDc7wpdiwvXBKn+QaoTCYcSc0pB2Z34uX/cFojAUVOAupClmaDp
         WLSofyek6rI5rHTswo32pZOMrTyevK3xfiYLTwr6nvoKBrjl7T3ksVKQrt/6dUrt3e
         uAmQwJENq35dg==
X-Virus-Scanned: amavisd-new at mail.cs.ucla.edu
Received: from mail.cs.ucla.edu ([127.0.0.1])
        by localhost (mail.cs.ucla.edu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 8bN8ek1Lf7j4 for <linux-cifs@vger.kernel.org>;
        Sat,  2 Sep 2023 12:02:13 -0700 (PDT)
Received: from [192.168.1.9] (cpe-172-91-119-151.socal.res.rr.com [172.91.119.151])
        by mail.cs.ucla.edu (Postfix) with ESMTPSA id 8EA3A3C011BDF
        for <linux-cifs@vger.kernel.org>; Sat,  2 Sep 2023 12:02:13 -0700 (PDT)
Content-Type: multipart/mixed; boundary="------------kX4so2sPkf0GNksWX0tGNxBg"
Message-ID: <fe8ab586-c697-583b-650d-3adac64df7b2@cs.ucla.edu>
Date:   Sat, 2 Sep 2023 12:02:13 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Content-Language: en-US
To:     linux-cifs@vger.kernel.org
From:   Paul Eggert <eggert@cs.ucla.edu>
Subject: wrong errno for chown etc. privilege failures in Linux CIFS client
Organization: UCLA Computer Science Department
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This is a multi-part message in MIME format.
--------------kX4so2sPkf0GNksWX0tGNxBg
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

In <https://bugs.gnu.org/65599> Bruno Haible reports that GNU cp and mv 
issue bogus diagnostics when copying from ext4 to cifs. We tracked this 
down to fchownat failing with EACCES when it should fail with EPERM.

To reproduce the fchownat bug, compile and run the attached program in a 
cifs subdirectory on Linux kernel 5.15. The program will issue 
EACCES-related diagnostics like this:

fchownat: Permission denied

whereas it should issue EPERM-related diagnostics like this:

fchownat: Operation not permitted

EACCES is wrong because POSIX says that EACCES means that search 
permission is denied on a component of the path prefix (a problem that 
does not apply here), whereas EPERM means the calling process does not 
have appropriate privileges to change ownership (the problem that does 
apply here). See 
<https://pubs.opengroup.org/onlinepubs/9699919799/functions/fchownat.html>.

We discovered similar problems with fchown, chown, lchown, fchmodat, 
lchmod, and chmod on CIFS. I assume fsetxattr etc. are also affected by 
the bug.

Although most programs don't care about the difference between EACCES 
and EPERM, GNU coreutils does care and I expect other programs will too, 
and it'd be nice if CIFS were fixed to not generate these false alarms.
--------------kX4so2sPkf0GNksWX0tGNxBg
Content-Type: text/x-csrc; charset=UTF-8; name="fchownat-test.c"
Content-Disposition: attachment; filename="fchownat-test.c"
Content-Transfer-Encoding: base64

I2RlZmluZSBfR05VX1NPVVJDRQojaW5jbHVkZSA8ZmNudGwuaD4KI2luY2x1ZGUgPHN0ZGlv
Lmg+CiNpbmNsdWRlIDxzeXMvc3RhdC5oPgojaW5jbHVkZSA8dW5pc3RkLmg+CgppbnQKbWFp
biAoaW50IGFyZ2MsIGNoYXIgKiphcmd2KQp7CiAgY2hhciBjb25zdCAqZmlsZSA9IGFyZ3Zb
MV0gPyBhcmd2WzFdIDogIi4iOwogIHN0cnVjdCBzdGF0IHN0OwogIGlmIChsc3RhdCAoZmls
ZSwgJnN0KSA8IDApCiAgICByZXR1cm4gcGVycm9yICgibHN0YXQiKSwgMTsKICBpbnQgc3Rh
dHVzID0gMDsKICBpZiAobGNob3duIChmaWxlLCBzdC5zdF91aWQsIHN0LnN0X2dpZCkgPCAw
KQogICAgcGVycm9yICgibGNob3duIiksIHN0YXR1cyA9IDE7CiAgaWYgKGZjaG93bmF0IChB
VF9GRENXRCwgZmlsZSwgc3Quc3RfdWlkLCBzdC5zdF9naWQsIEFUX1NZTUxJTktfTk9GT0xM
T1cpIDwgMCkKICAgIHBlcnJvciAoImZjaG93bmF0IiksIHN0YXR1cyA9IDE7CiAgaWYgKCFT
X0lTTE5LIChzdC5zdF9tb2RlKSkKICAgIHsKICAgICAgaWYgKGNob3duIChmaWxlLCBzdC5z
dF91aWQsIHN0LnN0X2dpZCkgPCAwKQoJcGVycm9yICgiY2hvd24iKSwgc3RhdHVzID0gMTsK
ICAgICAgaW50IGZkID0gb3BlbmF0IChBVF9GRENXRCwgZmlsZSwgT19SRE9OTFkgfCBPX05P
Rk9MTE9XKTsKICAgICAgaWYgKGZkIDwgMCkKCXBlcnJvciAoIm9wZW5hdCIpLCBzdGF0dXMg
PSAxOwogICAgICBlbHNlIGlmIChmY2hvd24gKGZkLCBzdC5zdF91aWQsIHN0LnN0X2dpZCkg
PCAwKQoJcGVycm9yICgiZmNob3duIiksIHN0YXR1cyA9IDE7CiAgICB9CiAgcmV0dXJuIHN0
YXR1czsKfQo=

--------------kX4so2sPkf0GNksWX0tGNxBg--
