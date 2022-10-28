Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6C61ECAAA1
	for <linux-cifs@archiver.kernel.org>; Fri, 28 Oct 2022 06:23:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbiJ1GXl (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 28 Oct 2022 02:23:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiJ1GXk (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 28 Oct 2022 02:23:40 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 264631B8668
        for <linux-cifs@vger.kernel.org>; Thu, 27 Oct 2022 23:23:39 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id be13so6719557lfb.4
        for <linux-cifs@vger.kernel.org>; Thu, 27 Oct 2022 23:23:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=f9OiZf7F2j2QujXK3pTSIi/FwLbrbracjDzDGTQPcmo=;
        b=hOfcXUyzl7gzaMxppNWqTMBQ9lPwYiOP9cB+m5FFh/cfECgh9ar34K8Fu+SmW3eudK
         bM5xQzUnVPkieQeUhI61h3Y94vpoEw6ALBvW15PDfda5jlAFit5fuSpY6effYGkjVTnx
         reaLOLO4TIItqw+RuV+Kw0STPqw+6VYDT4aEeV9IVS4iDf9cO3E8/hJbgfHtTRXvTdie
         r0/wY24tOq4VLdMY4POg/O3FUPzjP6kaKn7ZOb+iJmNvjl2GaFx7km6lQJ7YYI7NxJmx
         UI1CnB0I0bhH2A0iXxmO560l6aJo+jBkbJkbSh4xPbQ13UDhnkFqi1Y6mHH2lVh5GOVc
         7oSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=f9OiZf7F2j2QujXK3pTSIi/FwLbrbracjDzDGTQPcmo=;
        b=Jti85dN97dY58pL20dzySUn8Epic2MreixRbCDcNw9oATz9b8neW7M/0EJ5c45SddP
         l1VhBh2/iApIk3fCANZ8ZeCk+Lz0HpWCNvOcRO/8un0tscCiwLf0a8xdLve6hg4PlkBZ
         xknUBEjUmR1MdOKeLpoj/2wbE1RlmGpCp+y6FoyW/8IT/IKJJuWNTj+QqjvDaSe3CoPu
         N99tUprmjYulV2IpJVKnv8Q7FVgbiJqMGR4/xKMOJX2bDsxpKwqt20adJgYtTq3d8iKo
         26EhbIYb9wi6W46nu8Ce7adxccipDIvuxMFgaOcbXxokPn+XW3/EacDTkIJCvTV4PpzW
         IV0w==
X-Gm-Message-State: ACrzQf1ULLD1CbYgU9J73ekRavMv1jHLp+Q4MsC58iDyqx4iNC/oYO8F
        E1w7GDfp4cex8SnCqMipcFRM7ozgNBCFRlfI/ULo3M99sfA=
X-Google-Smtp-Source: AMsMyM76A1LnqxDTnfYKXqr2lSRi5XYSUATAwrNEMpeIJRxHykdbVKKb4MMQSwJum7clX/8S9zf1k3yTi6lurA332Uo=
X-Received: by 2002:a05:6512:6d4:b0:4a2:5045:db6a with SMTP id
 u20-20020a05651206d400b004a25045db6amr21735425lff.199.1666938216855; Thu, 27
 Oct 2022 23:23:36 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 28 Oct 2022 01:23:25 -0500
Message-ID: <CAH2r5muCMfv4HuPw6sEgKj3Ude3cz+-NRdxDXpJr3CNtUAnm7A@mail.gmail.com>
Subject: [PATCH][SMB3 client] fix oplock breaks when using multichannel
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@samba.org>
Content-Type: multipart/mixed; boundary="000000000000476d2105ec124cfd"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000476d2105ec124cfd
Content-Type: text/plain; charset="UTF-8"

If a mount to a server is using multichannel, an oplock break arriving
on a secondary channel won't find the open file (since it won't find the
tcon for it), and this will cause each oplock break on secondary channels
to time out, slowing performance drastically.

Fix smb2_is_valid_oplock_break so that if it is a secondary channel and
an oplock break was not found, check for tcons (and the files hanging
off the tcons) on the primary channel.

Fixes xfstest generic/013 to ksmbd

Cc: <stable@vger.kernel.org>


-- 
Thanks,

Steve

--000000000000476d2105ec124cfd
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-fix-oplock-break-when-using-multichannel.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-fix-oplock-break-when-using-multichannel.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_l9s3ykr30>
X-Attachment-Id: f_l9s3ykr30

RnJvbSAwMTg2YzBkNGM0MTgyNTFmMDY2Y2M4YzhkODBmMTY3ODNmOWRlZDAwIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IEZyaSwgMjggT2N0IDIwMjIgMDE6MTM6MTYgLTA1MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiBmaXggb3Bsb2NrIGJyZWFrIHdoZW4gdXNpbmcgbXVsdGljaGFubmVsCgpJZiBhIG1vdW50
IHRvIGEgc2VydmVyIGlzIHVzaW5nIG11bHRpY2hhbm5lbCwgYW4gb3Bsb2NrIGJyZWFrIGFycml2
aW5nCm9uIGEgc2Vjb25kYXJ5IGNoYW5uZWwgd29uJ3QgZmluZCB0aGUgb3BlbiBmaWxlIChzaW5j
ZSBpdCB3b24ndCBmaW5kIHRoZQp0Y29uIGZvciBpdCkuCgpGaXggc21iMl9pc192YWxpZF9vcGxv
Y2tfYnJlYWsgc28gdGhhdCBpZiBpdCBpcyBhIHNlY29uZGFyeSBjaGFubmVsIGFuZAphbiBvcGxv
Y2sgYnJlYWsgd2FzIG5vdCBmb3VuZCwgY2hlY2sgZm9yIHRjb25zIChhbmQgdGhlIGZpbGVzIGhh
bmdpbmcKb2ZmIHRoZSB0Y29ucykgb24gdGhlIHByaW1hcnkgY2hhbmVsLgoKRml4ZXMgeGZzdGVz
dCBnZW5lcmljLzAxMyB0byBrc21iZAoKQ2M6IDxzdGFibGVAdmdlci5rZXJuZWwub3JnPgpTaWdu
ZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+Ci0tLQogZnMv
Y2lmcy9zbWIybWlzYy5jIHwgNDcgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrLQogMSBmaWxlIGNoYW5nZWQsIDQ2IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24o
LSkKCmRpZmYgLS1naXQgYS9mcy9jaWZzL3NtYjJtaXNjLmMgYi9mcy9jaWZzL3NtYjJtaXNjLmMK
aW5kZXggYTM4NzIwNDc3OTY2Li5jY2QyOTRlNmM5ZDkgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvc21i
Mm1pc2MuYworKysgYi9mcy9jaWZzL3NtYjJtaXNjLmMKQEAgLTY4OSwxMyArNjg5LDU2IEBAIHNt
YjJfaXNfdmFsaWRfb3Bsb2NrX2JyZWFrKGNoYXIgKmJ1ZmZlciwgc3RydWN0IFRDUF9TZXJ2ZXJf
SW5mbyAqc2VydmVyKQogCQkJcmV0dXJuIGZhbHNlOwogCX0KIAotCWNpZnNfZGJnKEZZSSwgIm9w
bG9jayBsZXZlbCAweCV4XG4iLCByc3AtPk9wbG9ja0xldmVsKTsKKwljaWZzX2RiZyhGWUksICJv
cGxvY2sgbGV2ZWwgMHgleCBmaWQgMHglbGx4XG4iLAorCQkgcnNwLT5PcGxvY2tMZXZlbCwgcnNw
LT5QZXJzaXN0ZW50RmlkKTsKIAogCS8qIGxvb2sgdXAgdGNvbiBiYXNlZCBvbiB0aWQgJiB1aWQg
Ki8KIAlzcGluX2xvY2soJmNpZnNfdGNwX3Nlc19sb2NrKTsKIAlsaXN0X2Zvcl9lYWNoX2VudHJ5
KHNlcywgJnNlcnZlci0+c21iX3Nlc19saXN0LCBzbWJfc2VzX2xpc3QpIHsKIAkJbGlzdF9mb3Jf
ZWFjaF9lbnRyeSh0Y29uLCAmc2VzLT50Y29uX2xpc3QsIHRjb25fbGlzdCkgeworCQkJc3Bpbl9s
b2NrKCZ0Y29uLT5vcGVuX2ZpbGVfbG9jayk7CisJCQlsaXN0X2Zvcl9lYWNoX2VudHJ5KGNmaWxl
LCAmdGNvbi0+b3BlbkZpbGVMaXN0LCB0bGlzdCkgeworCQkJCWlmIChyc3AtPlBlcnNpc3RlbnRG
aWQgIT0KKwkJCQkgICAgY2ZpbGUtPmZpZC5wZXJzaXN0ZW50X2ZpZCB8fAorCQkJCSAgICByc3At
PlZvbGF0aWxlRmlkICE9CisJCQkJICAgIGNmaWxlLT5maWQudm9sYXRpbGVfZmlkKQorCQkJCQlj
b250aW51ZTsKKworCQkJCWNpZnNfZGJnKEZZSSwgImZpbGUgaWQgbWF0Y2gsIG9wbG9jayBicmVh
a1xuIik7CisJCQkJY2lmc19zdGF0c19pbmMoCisJCQkJICAgICZ0Y29uLT5zdGF0cy5jaWZzX3N0
YXRzLm51bV9vcGxvY2tfYnJrcyk7CisJCQkJY2lub2RlID0gQ0lGU19JKGRfaW5vZGUoY2ZpbGUt
PmRlbnRyeSkpOworCQkJCXNwaW5fbG9jaygmY2ZpbGUtPmZpbGVfaW5mb19sb2NrKTsKKwkJCQlp
ZiAoIUNJRlNfQ0FDSEVfV1JJVEUoY2lub2RlKSAmJgorCQkJCSAgICByc3AtPk9wbG9ja0xldmVs
ID09IFNNQjJfT1BMT0NLX0xFVkVMX05PTkUpCisJCQkJCWNmaWxlLT5vcGxvY2tfYnJlYWtfY2Fu
Y2VsbGVkID0gdHJ1ZTsKKwkJCQllbHNlCisJCQkJCWNmaWxlLT5vcGxvY2tfYnJlYWtfY2FuY2Vs
bGVkID0gZmFsc2U7CiAKKwkJCQlzZXRfYml0KENJRlNfSU5PREVfUEVORElOR19PUExPQ0tfQlJF
QUssCisJCQkJCSZjaW5vZGUtPmZsYWdzKTsKKworCQkJCWNmaWxlLT5vcGxvY2tfZXBvY2ggPSAw
OworCQkJCWNmaWxlLT5vcGxvY2tfbGV2ZWwgPSByc3AtPk9wbG9ja0xldmVsOworCisJCQkJc3Bp
bl91bmxvY2soJmNmaWxlLT5maWxlX2luZm9fbG9jayk7CisKKwkJCQljaWZzX3F1ZXVlX29wbG9j
a19icmVhayhjZmlsZSk7CisKKwkJCQlzcGluX3VubG9jaygmdGNvbi0+b3Blbl9maWxlX2xvY2sp
OworCQkJCXNwaW5fdW5sb2NrKCZjaWZzX3RjcF9zZXNfbG9jayk7CisJCQkJcmV0dXJuIHRydWU7
CisJCQl9CisJCQlzcGluX3VubG9jaygmdGNvbi0+b3Blbl9maWxlX2xvY2spOworCQl9CisJfQor
CisJLyogaWYgZmlsZSBub3QgZm91bmQgYW5kIHNlY29uZGFyeSwgY2hlY2sgcHJpbWFyeSBjaGFu
bmVsICovCisJaWYgKHNlcnZlci0+cHJpbWFyeV9zZXJ2ZXIgPT0gTlVMTCkKKwkJZ290byB2YWxp
ZF9vcGxvY2tfbm90X2ZvdW5kOworCisJbGlzdF9mb3JfZWFjaF9lbnRyeShzZXMsICZzZXJ2ZXIt
PnByaW1hcnlfc2VydmVyLT5zbWJfc2VzX2xpc3QsIHNtYl9zZXNfbGlzdCkgeworCQlsaXN0X2Zv
cl9lYWNoX2VudHJ5KHRjb24sICZzZXMtPnRjb25fbGlzdCwgdGNvbl9saXN0KSB7CiAJCQlzcGlu
X2xvY2soJnRjb24tPm9wZW5fZmlsZV9sb2NrKTsKIAkJCWxpc3RfZm9yX2VhY2hfZW50cnkoY2Zp
bGUsICZ0Y29uLT5vcGVuRmlsZUxpc3QsIHRsaXN0KSB7CiAJCQkJaWYgKHJzcC0+UGVyc2lzdGVu
dEZpZCAhPQpAQCAtNzMyLDYgKzc3NSw4IEBAIHNtYjJfaXNfdmFsaWRfb3Bsb2NrX2JyZWFrKGNo
YXIgKmJ1ZmZlciwgc3RydWN0IFRDUF9TZXJ2ZXJfSW5mbyAqc2VydmVyKQogCQkJc3Bpbl91bmxv
Y2soJnRjb24tPm9wZW5fZmlsZV9sb2NrKTsKIAkJfQogCX0KKwordmFsaWRfb3Bsb2NrX25vdF9m
b3VuZDoKIAlzcGluX3VubG9jaygmY2lmc190Y3Bfc2VzX2xvY2spOwogCWNpZnNfZGJnKEZZSSwg
Ik5vIGZpbGUgaWQgbWF0Y2hlZCwgb3Bsb2NrIGJyZWFrIGlnbm9yZWRcbiIpOwogCXRyYWNlX3Nt
YjNfb3Bsb2NrX25vdF9mb3VuZCgwIC8qIG5vIHhpZCAqLywgcnNwLT5QZXJzaXN0ZW50RmlkLAot
LSAKMi4zNC4xCgo=
--000000000000476d2105ec124cfd--
