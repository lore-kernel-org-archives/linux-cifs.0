Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3219738B
	for <linux-cifs@vger.kernel.org>; Tue,  7 Nov 2023 04:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GH0j8J/N"
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55076FD
	for <linux-cifs@vger.kernel.org>; Mon,  6 Nov 2023 20:43:01 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id 2adb3069b0e04-509109104e2so6862305e87.3
        for <linux-cifs@vger.kernel.org>; Mon, 06 Nov 2023 20:43:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699332179; x=1699936979; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=4HB4n7MRJafoCUjnai4jeZh3LhBUXHcniK4G0oAK5d8=;
        b=GH0j8J/NiFPqBKzSzqJ1Ihy03XJKebrhxWMWl0gq77EvSnKjIkRR+d4njdG4/Skm0Y
         WY1ZP/kY933VrmwmlApJckAmLKrKoMGYPhgJ6lq0d3/YA7XXNzTqmeofcdZD0F6sdHXc
         nHQswEb2SKzjUY+fJITkpqyOZtoE17PcgYk20kO57CCuSq32o+SOG77j7sO4pW2SipyI
         O3q4O6TVwFXUu/dMZdmyVqaPrA0ETQS1GEUbNb9FR2gIyvH/Bs93VQAOfSH3rIgNWOBJ
         LZPuYLtUi7PX4V2xJ/yv4yaGleIn/Fv9X3ldDsquRv4QZs6iyNtwxvZRXeC0xTcs2/v3
         3V1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699332179; x=1699936979;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4HB4n7MRJafoCUjnai4jeZh3LhBUXHcniK4G0oAK5d8=;
        b=NwjCfPbNYeyEH2OEA3G3L+jDmGkFQk4dEo/BE/niTP6oAUXON8Fa5msjHHBtTAX9KG
         3L4NhvtxpkTRtHN95EXXSe/8TDksOi1Wov13yp3waiEoKGs+mEVMKOFQGXYI3hDAsKI3
         7qlcN5xco3NkrNEyW9k8cKjqWTi+ayUywO573mM1atbVnsDIsQXGSku6dnuFM4FBZIVg
         PvoffCpbbPD5S7q+LMf/MLolZnxcbwY/K6fA57QOr/22WGsHyc4/rzepqF3UnLdWppKD
         inn6q7M2gKzo5vPpaMuKyygKt9WncRWoI7ZImWzXPLRBkCKC8HKsHWUUnByssE9ba2jI
         NicQ==
X-Gm-Message-State: AOJu0YyBgPINcCMcwg3nxPDVdZjkR8d1u+UxNhWW2iILR2QroQqeEeXB
	P/RAmC2NnxXoD1iQVi/WGve//26Muz6N7rhzGDa/z7wzSPo4XRKr
X-Google-Smtp-Source: AGHT+IGms/NfkW/K5ZtbD6ziMwlEUAV74QD+frdu8vrZuYDGTpM6Ktoi6GrJNT1ttGKy5x7/iboTxqP6acBK4tvKmlU=
X-Received: by 2002:ac2:4e08:0:b0:509:2b57:32e with SMTP id
 e8-20020ac24e08000000b005092b57032emr22345815lfr.8.1699332178710; Mon, 06 Nov
 2023 20:42:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Mon, 6 Nov 2023 22:42:47 -0600
Message-ID: <CAH2r5muqSPutkdHgmBNQbUh=YQVr+7N4tV4GVM2hWa2ZsQHaqQ@mail.gmail.com>
Subject: Minor cleanup patch - and question about returning -ENOSYS
To: CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000de61be0609889a92"

--000000000000de61be0609889a92
Content-Type: text/plain; charset="UTF-8"

Attached is another minor cleanup of comments pointed out by checkpatch ...
but checkpatch also complains about these two places in sess.c (see
below in select_sec function) where we return -ENOSYS (since
apparently it can only be returned for invalid syscall). Any thoughts?

static int select_sec(struct sess_data *sess_data)
{
        int type;
        struct cifs_ses *ses = sess_data->ses;
        struct TCP_Server_Info *server = sess_data->server;

        type = cifs_select_sectype(server, ses->sectype);
        cifs_dbg(FYI, "sess setup type %d\n", type);
        if (type == Unspecified) {
                cifs_dbg(VFS, "Unable to select appropriate
authentication method!\n");
                return -EINVAL;
        }

        switch (type) {
        case NTLMv2:
                sess_data->func = sess_auth_ntlmv2;
                break;
        case Kerberos:
#ifdef CONFIG_CIFS_UPCALL
                sess_data->func = sess_auth_kerberos;
                break;
#else
                cifs_dbg(VFS, "Kerberos negotiated but upcall support
disabled!\n");
                return -ENOSYS;
#endif /* CONFIG_CIFS_UPCALL */
        case RawNTLMSSP:
                sess_data->func = sess_auth_rawntlmssp_negotiate;
                break;
        default:
                cifs_dbg(VFS, "secType %d not supported!\n", type);
                return -ENOSYS;
        }


-- 
Thanks,

Steve

--000000000000de61be0609889a92
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-more-minor-cleanups-for-session-handling-routin.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-more-minor-cleanups-for-session-handling-routin.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_lonuh90t0>
X-Attachment-Id: f_lonuh90t0

RnJvbSAwYmZmZWVkMDEzZWM4NDA4NGJjNTA5MGIzNzdkMjE4M2VmYThkNzJiIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IE1vbiwgNiBOb3YgMjAyMyAyMjo0MDozOCAtMDYwMApTdWJqZWN0OiBbUEFUQ0hdIHNt
YjM6IG1vcmUgbWlub3IgY2xlYW51cHMgZm9yIHNlc3Npb24gaGFuZGxpbmcgcm91dGluZXMKClNv
bWUgdHJpdmlhbCBjbGVhbnVwIHBvaW50ZWQgb3V0IGJ5IGNoZWNrcGF0Y2gKClNpZ25lZC1vZmYt
Ynk6IFN0ZXZlIEZyZW5jaCA8c3RmcmVuY2hAbWljcm9zb2Z0LmNvbT4KLS0tCiBmcy9zbWIvY2xp
ZW50L3Nlc3MuYyB8IDI1ICsrKysrKysrKysrKysrKy0tLS0tLS0tLS0KIDEgZmlsZSBjaGFuZ2Vk
LCAxNSBpbnNlcnRpb25zKCspLCAxMCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9zbWIv
Y2xpZW50L3Nlc3MuYyBiL2ZzL3NtYi9jbGllbnQvc2Vzcy5jCmluZGV4IDlkNzFjMjNmZTIzNC4u
NmZkMDc0ZmNhZTViIDEwMDY0NAotLS0gYS9mcy9zbWIvY2xpZW50L3Nlc3MuYworKysgYi9mcy9z
bWIvY2xpZW50L3Nlc3MuYwpAQCAtODEyLDggKzgxMiw3IEBAIHN0YXRpYyB2b2lkIGFzY2lpX3Nz
ZXR1cF9zdHJpbmdzKGNoYXIgKipwYmNjX2FyZWEsIHN0cnVjdCBjaWZzX3NlcyAqc2VzLAogCQlp
ZiAoV0FSTl9PTl9PTkNFKGxlbiA8IDApKQogCQkJbGVuID0gQ0lGU19NQVhfRE9NQUlOTkFNRV9M
RU4gLSAxOwogCQliY2NfcHRyICs9IGxlbjsKLQl9IC8qIGVsc2Ugd2Ugd2lsbCBzZW5kIGEgbnVs
bCBkb21haW4gbmFtZQotCSAgICAgc28gdGhlIHNlcnZlciB3aWxsIGRlZmF1bHQgdG8gaXRzIG93
biBkb21haW4gKi8KKwl9IC8qIGVsc2Ugd2Ugc2VuZCBhIG51bGwgZG9tYWluIG5hbWUgc28gc2Vy
dmVyIHdpbGwgZGVmYXVsdCB0byBpdHMgb3duIGRvbWFpbiAqLwogCSpiY2NfcHRyID0gMDsKIAli
Y2NfcHRyKys7CiAKQEAgLTkwOSwxMSArOTA4LDE0IEBAIHN0YXRpYyB2b2lkIGRlY29kZV9hc2Np
aV9zc2V0dXAoY2hhciAqKnBiY2NfYXJlYSwgX191MTYgYmxlZnQsCiAJaWYgKGxlbiA+IGJsZWZ0
KQogCQlyZXR1cm47CiAKLQkvKiBObyBkb21haW4gZmllbGQgaW4gTEFOTUFOIGNhc2UuIERvbWFp
biBpcwotCSAgIHJldHVybmVkIGJ5IG9sZCBzZXJ2ZXJzIGluIHRoZSBTTUIgbmVncHJvdCByZXNw
b25zZSAqLwotCS8qIEJCIEZvciBuZXdlciBzZXJ2ZXJzIHdoaWNoIGRvIG5vdCBzdXBwb3J0IFVu
aWNvZGUsCi0JICAgYnV0IHRodXMgZG8gcmV0dXJuIGRvbWFpbiBoZXJlIHdlIGNvdWxkIGFkZCBw
YXJzaW5nCi0JICAgZm9yIGl0IGxhdGVyLCBidXQgaXQgaXMgbm90IHZlcnkgaW1wb3J0YW50ICov
CisJLyoKKwkgKiBObyBkb21haW4gZmllbGQgaW4gTEFOTUFOIGNhc2UuIERvbWFpbiBpcworCSAq
IHJldHVybmVkIGJ5IG9sZCBzZXJ2ZXJzIGluIHRoZSBTTUIgbmVncHJvdCByZXNwb25zZQorCSAq
CisJICogQkIgRm9yIG5ld2VyIHNlcnZlcnMgd2hpY2ggZG8gbm90IHN1cHBvcnQgVW5pY29kZSwK
KwkgKiBidXQgdGh1cyBkbyByZXR1cm4gZG9tYWluIGhlcmUsIHdlIGNvdWxkIGFkZCBwYXJzaW5n
CisJICogZm9yIGl0IGxhdGVyLCBidXQgaXQgaXMgbm90IHZlcnkgaW1wb3J0YW50CisJICovCiAJ
Y2lmc19kYmcoRllJLCAiYXNjaWk6IGJ5dGVzIGxlZnQgJWRcbiIsIGJsZWZ0KTsKIH0KICNlbmRp
ZiAvKiBDT05GSUdfQ0lGU19BTExPV19JTlNFQ1VSRV9MRUdBQ1kgKi8KQEAgLTk2OSw5ICs5NzEs
MTIgQEAgaW50IGRlY29kZV9udGxtc3NwX2NoYWxsZW5nZShjaGFyICpiY2NfcHRyLCBpbnQgYmxv
Yl9sZW4sCiAJc2VzLT5udGxtc3NwLT5zZXJ2ZXJfZmxhZ3MgPSBzZXJ2ZXJfZmxhZ3M7CiAKIAlt
ZW1jcHkoc2VzLT5udGxtc3NwLT5jcnlwdGtleSwgcGJsb2ItPkNoYWxsZW5nZSwgQ0lGU19DUllQ
VE9fS0VZX1NJWkUpOwotCS8qIEluIHBhcnRpY3VsYXIgd2UgY2FuIGV4YW1pbmUgc2lnbiBmbGFn
cyAqLwotCS8qIEJCIHNwZWMgc2F5cyB0aGF0IGlmIEF2SWQgZmllbGQgb2YgTXN2QXZUaW1lc3Rh
bXAgaXMgcG9wdWxhdGVkIHRoZW4KLQkJd2UgbXVzdCBzZXQgdGhlIE1JQyBmaWVsZCBvZiB0aGUg
QVVUSEVOVElDQVRFX01FU1NBR0UgKi8KKwkvKgorCSAqIEluIHBhcnRpY3VsYXIgd2UgY2FuIGV4
YW1pbmUgc2lnbiBmbGFncworCSAqCisJICogQkIgc3BlYyBzYXlzIHRoYXQgaWYgQXZJZCBmaWVs
ZCBvZiBNc3ZBdlRpbWVzdGFtcCBpcyBwb3B1bGF0ZWQgdGhlbgorCSAqIHdlIG11c3Qgc2V0IHRo
ZSBNSUMgZmllbGQgb2YgdGhlIEFVVEhFTlRJQ0FURV9NRVNTQUdFCisJICovCiAKIAl0aW9mZnNl
dCA9IGxlMzJfdG9fY3B1KHBibG9iLT5UYXJnZXRJbmZvQXJyYXkuQnVmZmVyT2Zmc2V0KTsKIAl0
aWxlbiA9IGxlMTZfdG9fY3B1KHBibG9iLT5UYXJnZXRJbmZvQXJyYXkuTGVuZ3RoKTsKLS0gCjIu
MzkuMgoK
--000000000000de61be0609889a92--
