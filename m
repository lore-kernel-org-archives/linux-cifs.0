Received: from mail-vs1-f48.google.com (mail-vs1-f48.google.com [209.85.217.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67AD53E0C46
	for <linux-cifs@vger.kernel.org>; Sat, 29 Aug 2026 16:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.217.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788019297; cv=pass; b=XYJ3gV5Qf4nGDY3SgJyx77v7KDmArllTj5e5LTKTYpwPko7weklmtxgXhHRp63k5wgIRtlFBCH2RGmBC8nXZBKaIDuaZrsaR3NjdWLFcdl4Cpz58Rto1zX5Y1J819z1DGfZTbGdUgVA2czV7dH6rEJI5fKLXaXM92QGtv6FpwJ8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788019297; c=relaxed/simple;
	bh=zi9dN8zHx74QQmEFV7pBfsrgSfnp0SLRsKrWByQCMJQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XtcvhCCYBNJ4SXgib0bKDr2SkANGu+IqizngOkW+b6JrJ0RVpUTd4nYCHsO8ZETYUW+DzpFD+ztNRne5ldG31PCS6b2mJ4Srp3ujD2J2bCUfSasDpDhdADr3st+ZYCpZ0Kk+K1Y/sbKklhOSZBC3fJ6Pd8mZtI5RsgnwtZR+5UY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cLPvnfFP; arc=pass smtp.client-ip=209.85.217.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cLPvnfFP"
Received: by mail-vs1-f48.google.com with SMTP id ada2fe7eead31-765c077b5c1so642305137.3
        for <linux-cifs@vger.kernel.org>; Sat, 29 Aug 2026 09:01:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788019292; cv=none;
        d=google.com; s=arc-20260327;
        b=oFivNYLPS/0L1Crwj4WPVo20WH1zg6LozrzH7EK9Wx6pzQBT6OgSPqXa94YFOUJoLL
         LLGTlApQBRnJhaw7J928ocI9DkjaARxp5RZugPyMxq7T2y8XLPqEklaK4qsxNnktwSYk
         On7lJmtAxQZJi28UK4/3o7gm/6nmMCOlGokBmHUP9Eo7DWan5R9OI5ZwTAZqvpVgOlKM
         y3M1U3g4Fa1NA+jkTjJ4c7rq9nUMFrLpIoNNzrtbpX7E/Uygy+4uDITM2OypRTEQtXev
         6tTYAOuZmyRCtikBTCjGZjaMcU0ZyYvuRMYoxk/+N95shPyNqVITx33r3ORIWLs3w1gP
         JjyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=Ia7ATP/llObkovxPYKMmKmEmwn53mFWqO2GffcQMStE=;
        fh=T+e/HiSO9MpWj/lw7ZinNGr83WC6jdApZR/CFBMj95U=;
        b=ScsaAw3lijDu6LH8F/sXHYGjB/GWueWQLx+pYe7vzQFMA0BQHaqQs86aUinKi5V85T
         lkmPr3D3w4WWVqq5XkD37SwebsHBmUghTGXUrG6/FOrCBAg4BCXxCgGR/mRK+m3Ftjrs
         Z4CDSjG+RiI3YowLKwrXqGB4sso2hOKrKsToAWA2muaEIA1eCmrnj8JfOPsmj8gzhmOo
         WAH7afZpxqwt2E39i2tMm1A+lGg6IVP+xzqJS1RlH/ZQW73jc3dqmLRQHnb4mYyzmJiL
         DogMiB3VMvUvG1UjfnsuNgYat9Cu4v3Rlz5m77ngQl187x4MM/032qbgrKryiOtSnpZX
         QYuA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788019292; x=1788624092; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ia7ATP/llObkovxPYKMmKmEmwn53mFWqO2GffcQMStE=;
        b=cLPvnfFPis76SgWPRS4qQTPYtX0ivq7mQgp58TDleNigAa5usGMg9lumRVCRdkxjbQ
         cBDJXSE5e8M6Gwjbtl01LlgeQ0L90UqV6xZfE1QUSypplO/8E/o6f4s7p57G8xPoYcry
         1UudrCrkIABjAXdnHrbEKpASTadHrAAYY+2PbombkpDWFBfA6z1hoKqPHjEg/p5WxD8F
         aL1QA4Gm5CJ2C4HbyQkdEJKy87e3rMhtGR9e0ElSeaTWXDs/gN8rh7mdKltZWBPza4ZW
         DUNr3VBR2czeMifnPVD5C07HKmEHBsUyY4i/YBV8MTdK/ie0UJ1A+mZTpta8lEjfFhsC
         Tnsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788019292; x=1788624092;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Ia7ATP/llObkovxPYKMmKmEmwn53mFWqO2GffcQMStE=;
        b=jbxg6BVgBp1KfLgu5qYaosm5OkPrt3Fl7Sa1xF5s573AaclDwh/jIRXZHIe7pTsyMd
         NctTqLXoPCLE2kdwbZpveZoGFgGBAyIG7NOqoDSHxczC1O2XzkIjisUJdU8LMHmDdp2t
         J6UpgAhAQ/I7tW7PqMVKS0nUkU2yT+U3IwqmVSGmjspowsTkBf5kmeFaztO7cnTAn4rT
         leH/U59DzwPgI9z7MdRXvW0YTUlGYhHF96zjiGmejN3dg1mdGuoeektvtu2yhqRMS4FO
         vfhhYrEbbxBrB/uJqjOMZUU3fnhfNRSQ8zeL5BpndGSlvGGVOODV5NAJbPlP7kqeictF
         n7Xg==
X-Gm-Message-State: AFuF++l24eRBEstl8xtMbRUgyCXfuRSQuIm2uXBMv9E8c2fHIpdL9She
	uAOsPnM5h1v7oisagLQumv3IFZl64Gx/8KC7ZG1LADTKrXSYoCCLOwkt9tBi0jfeY0rp2RhkrRP
	zA+SCr0O/VnaUbJiUX2bKBvWkXMgMMV0=
X-Gm-Gg: AR+sD13DEO2YKfvs1BjR4j7mcO70K1EKWY/4FLS26czzT2YBfHtb5w3Tc3ceYzOEx/X
	nFA4SVvVZYgjsuO2lk//CYcuCeYCcPu0vG3BxdJYHiAQLN125lnyj7c91/mSn/PwvWnXT0fpVY4
	08MNchWTdoGXNvEZfytmOvntBJFsk5J4Dw+CS8ZNeyWtPzRHHZ1V5qUa8CpV4GcsjjogjmzYGTr
	JICmfBGSj/h8yhD7TPuvom0B/ZbWQ1sRk96m7rL9+gr7ssQpMTkVRrkHWWK7yaLLdkZTSMMZY+y
	avfMRlzRfpweUFTKBWgsrVPNRaqGI6Uu5GdU5EeGzPR5
X-Received: by 2002:a05:6102:508b:b0:787:74cc:2cff with SMTP id
 ada2fe7eead31-78774cc4a2amr1692649137.3.1788019292269; Sat, 29 Aug 2026
 09:01:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260829113917.26882-1-suruurism@gmail.com> <CAKYAXd-PDvGyUc7834fVGAvDGnqaOxcrJE6XXMF22eLS5=dzLw@mail.gmail.com>
In-Reply-To: <CAKYAXd-PDvGyUc7834fVGAvDGnqaOxcrJE6XXMF22eLS5=dzLw@mail.gmail.com>
From: Suruur <suruurism@gmail.com>
Date: Sat, 29 Aug 2026 19:01:20 +0300
X-Gm-Features: AcwNN1U3M4YR9z-yTulWnPUQrE501eOGRklKEUIu4IbenPEqRpQS4aeZPLZ6g28
Message-ID: <CAFkjbpD7BrK3xtG6m7d3QAuLN4xO-VG5UPF81obBGjREgVy0pg@mail.gmail.com>
Subject: Re: [PATCH v2] ksmbd: fix use-after-free in oplock break notification
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org, senozhatsky@chromium.org, tom@talpey.com
Content-Type: multipart/mixed; boundary="000000000000c49ce8065a31aeee"

--000000000000c49ce8065a31aeee
Content-Type: multipart/alternative; boundary="000000000000c49ce7065a31aeec"

--000000000000c49ce7065a31aeec
Content-Type: text/plain; charset="UTF-8"

Hi Namjae,

On Sat, Aug 29, 2026, Namjae Jeon wrote:
> > +
> > +static inline struct ksmbd_inode *ksmbd_inode_ref(struct ksmbd_inode
*ci)
> > +{
> > +       atomic_inc(&ci->m_count);
> Using m_count to pin o_ci breaks delete-on-close. The last file close
> will no longer drop m_count to zero, so __ksmbd_inode_close() can skip
> unlinking a delete-pending file.

You're right, thank you. Holding the extra m_count reference until the
oplock_info is RCU-freed delays the drop to zero that
__ksmbd_inode_close() keys the delete-on-close unlink on, so a
delete-pending file opened with an oplock would never be unlinked.

v3 drops the inode reference entirely. The notification path does not
need one: every caller of oplock_break() already holds a live
ksmbd_file (or an explicit ksmbd_inode_lookup_lock() reference in the
parent lease break paths) on the inode that owns the break target's
oplock list, so ci is pinned for the duration of the call. The
caller's inode is threaded through oplock_break() into
smb2_oplock_break_noti(), which takes ci->m_lock to select and pin the
connection without ever dereferencing opinfo->o_fp.

opinfo->conn is updated under ci->m_lock by both session_fd_check()
(clear on disconnect) and ksmbd_reopen_durable_fd() (reassign
reconnect), so holding the read lock also prevents the oplock's
connection reference from being dropped while the notification
it - the same shape as the lease fix in commit 3a98de41b0a4d.

Please see the v3 patch attached.

Regards,
Abdifatah Suruur

On Sat, 29 Aug 2026 at 16:43, Namjae Jeon <linkinjeon@kernel.org> wrote:

> > +
> > +static inline struct ksmbd_inode *ksmbd_inode_ref(struct ksmbd_inode
> *ci)
> > +{
> > +       atomic_inc(&ci->m_count);
> Using m_count to pin o_ci breaks delete-on-close. The last file close
> will no longer drop m_count to zero, so __ksmbd_inode_close() can skip
> unlinking a delete-pending file.
>
> > +       return ci;
> > +}
> >  bool ksmbd_close_disconnected_durable_delete_on_close(struct dentry
> *dentry);
> >  struct ksmbd_file *ksmbd_lookup_global_fd(unsigned long long id);
> >  struct ksmbd_file *ksmbd_lookup_durable_fd(unsigned long long id);
> > --
> > 2.53.0
> >
>

--000000000000c49ce7065a31aeec
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi Namjae,<br><br>On Sat, Aug 29, 2026, Namjae Jeon wrote:=
<br>&gt; &gt; +<br>&gt; &gt; +static inline struct ksmbd_inode *ksmbd_inode=
_ref(struct ksmbd_inode *ci)<br>&gt; &gt; +{<br>&gt; &gt; + =C2=A0 =C2=A0 =
=C2=A0 atomic_inc(&amp;ci-&gt;m_count);<br>&gt; Using m_count to pin o_ci b=
reaks delete-on-close. The last file close<br>&gt; will no longer drop m_co=
unt to zero, so __ksmbd_inode_close() can skip<br>&gt; unlinking a delete-p=
ending file.<br><br>You&#39;re right, thank you. Holding the extra m_count =
reference until the<br>oplock_info is RCU-freed delays the drop to zero tha=
t<br>__ksmbd_inode_close() keys the delete-on-close unlink on, so a<br>dele=
te-pending file opened with an oplock would never be unlinked.<br><br>v3 dr=
ops the inode reference entirely. The notification path does not<br>need on=
e: every caller of oplock_break() already holds a live<br>ksmbd_file (or an=
 explicit ksmbd_inode_lookup_lock() reference in the<br>parent lease break =
paths) on the inode that owns the break target&#39;s<br>oplock list, so ci =
is pinned for the duration of the call. The<br>caller&#39;s inode is thread=
ed through oplock_break() into<br>smb2_oplock_break_noti(), which takes ci-=
&gt;m_lock to select and pin the<br>connection without ever dereferencing o=
pinfo-&gt;o_fp.<br><br>opinfo-&gt;conn is updated under ci-&gt;m_lock by bo=
th session_fd_check()<br>(clear on disconnect) and ksmbd_reopen_durable_fd(=
) (reassign<br>reconnect), so holding the read lock also prevents the oploc=
k&#39;s<br>connection reference from being dropped while the notification<b=
r>it - the same shape as the lease fix in commit 3a98de41b0a4d.<br><br>Plea=
se see the v3 patch attached.<br><br>Regards,<br>Abdifatah Suruur</div><br>=
<div class=3D"gmail_quote gmail_quote_container"><div dir=3D"ltr" class=3D"=
gmail_attr">On Sat, 29 Aug 2026 at 16:43, Namjae Jeon &lt;<a href=3D"mailto=
:linkinjeon@kernel.org">linkinjeon@kernel.org</a>&gt; wrote:<br></div><bloc=
kquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:=
1px solid rgb(204,204,204);padding-left:1ex">&gt; +<br>
&gt; +static inline struct ksmbd_inode *ksmbd_inode_ref(struct ksmbd_inode =
*ci)<br>
&gt; +{<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0atomic_inc(&amp;ci-&gt;m_count);<br>
Using m_count to pin o_ci breaks delete-on-close. The last file close<br>
will no longer drop m_count to zero, so __ksmbd_inode_close() can skip<br>
unlinking a delete-pending file.<br>
<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0return ci;<br>
&gt; +}<br>
&gt;=C2=A0 bool ksmbd_close_disconnected_durable_delete_on_close(struct den=
try *dentry);<br>
&gt;=C2=A0 struct ksmbd_file *ksmbd_lookup_global_fd(unsigned long long id)=
;<br>
&gt;=C2=A0 struct ksmbd_file *ksmbd_lookup_durable_fd(unsigned long long id=
);<br>
&gt; --<br>
&gt; 2.53.0<br>
&gt;<br>
</blockquote></div>

--000000000000c49ce7065a31aeec--
--000000000000c49ce8065a31aeee
Content-Type: application/octet-stream; name="ksmbd-fix-v3.patch"
Content-Disposition: attachment; filename="ksmbd-fix-v3.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_mtekif7p0>
X-Attachment-Id: f_mtekif7p0

RnJvbSA5NGUwZTY1M2M1YWEwMDIwZTBkYWZiNGM3Y2Q4ZDhjY2VlODhiYWRiIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBYmRpZmF0YWggU3VydXVyIDxzdXJ1dXJpc21AZ21haWwuY29t
PgpEYXRlOiBTYXQsIDI5IEF1ZyAyMDI2IDE4OjQwOjIyICswMzAwClN1YmplY3Q6IFtQQVRDSCB2
M10ga3NtYmQ6IGZpeCB1c2UtYWZ0ZXItZnJlZSBpbiBvcGxvY2sgYnJlYWsgbm90aWZpY2F0aW9u
CgpzbWIyX29wbG9ja19icmVha19ub3RpKCkgcmVhZHMgb3BpbmZvLT5jb25uIHdpdGhvdXQgYW55
IGxvY2sgYW5kCmRlcmVmZXJlbmNlcyBpdCBhZnRlciB0d28gYWxsb2NhdGlvbnMgd2hpY2ggbWF5
IHNsZWVwLiAgV2hlbiB0aGUKZHVyYWJsZSBoYW5kbGUgb3duaW5nIHRoZSBvcGxvY2sgaXMgZGlz
Y29ubmVjdGVkLCBzZXNzaW9uX2ZkX2NoZWNrKCkKY2xlYXJzIG9waW5mby0+Y29ubiBhbmQgZHJv
cHMgaXRzIGNvbm4gcmVmZXJlbmNlIHVuZGVyIGNpLT5tX2xvY2ssIGFuZAp0aGUgbGFzdCBrc21i
ZF9jb25uX3B1dCgpIGZyZWVzIHRoZSBjb25uZWN0aW9uLiAgQSBicmVhayB0cmlnZ2VyZWQgYnkK
YW5vdGhlciBjb25uZWN0aW9uIHRoYXQgcmFjZXMgd2l0aCB0aGUgdGVhcmRvd24gY2FuIHRoZW4g
cmVzdXJyZWN0IHRoZQpmcmVlZCBjb25uZWN0aW9uOiBrc21iZF9jb25uX2dldCgpIGlzIGEgcGxh
aW4gYXRvbWljX2luYywgYW5kIHRoZQpxdWV1ZWQgYnJlYWsgd29yayBsYXRlciBkZXJlZmVyZW5j
ZXMgdGhlIHN0YWxlIGNvbm4gdmlhCmtzbWJkX2Nvbm5fd3JpdGUoKSwgYSB1c2UtYWZ0ZXItZnJl
ZSByZWFjaGFibGUgYnkgYW55IGF1dGhlbnRpY2F0ZWQKY2xpZW50IGhvbGRpbmcgYSBkdXJhYmxl
IGJhdGNoIG9wbG9jay4KClRocmVhZCB0aGUgY2FsbGVyJ3MgaW5vZGUgaW50byB0aGUgbm90aWZp
Y2F0aW9uIHBhdGggaW5zdGVhZCBvZiB0YWtpbmcKYSBuZXcgcmVmZXJlbmNlIG9uIGl0LiAgRXZl
cnkgY2FsbGVyIG9mIG9wbG9ja19icmVhaygpIGFscmVhZHkgaG9sZHMgYQpsaXZlIGtzbWJkX2Zp
bGUgKG9yIGFuIGV4cGxpY2l0IGtzbWJkX2lub2RlX2xvb2t1cF9sb2NrKCkgcmVmZXJlbmNlLApp
biB0aGUgcGFyZW50IGxlYXNlIGJyZWFrIHBhdGhzKSBvbiB0aGUgaW5vZGUgdGhhdCBvd25zIHRo
ZSBicmVhawp0YXJnZXQncyBvcGxvY2sgbGlzdCwgc28gY2kgY2Fubm90IGJlIGZyZWVkIGR1cmlu
ZyB0aGUgY2FsbCwgYW5kIGl0cwpsb2NrIGNhbiBiZSB0YWtlbiB3aXRob3V0IGRlcmVmZXJlbmNp
bmcgb3BpbmZvLT5vX2ZwLCB3aGljaCBhCmNvbmN1cnJlbnQgY2xvc2UgbWF5IGZyZWUuICBTZWxl
Y3QgYW5kIHBpbiB0aGUgY29ubmVjdGlvbiB1bmRlcgpjaS0+bV9sb2NrLCB0aGUgc2FtZSBsb2Nr
IHNlc3Npb25fZmRfY2hlY2soKSBhbmQKa3NtYmRfcmVvcGVuX2R1cmFibGVfZmQoKSB1c2UgdG8g
dXBkYXRlIG9waW5mby0+Y29ubiwgc28gYSBjb25jdXJyZW50CmRldGFjaCBlaXRoZXIgbG9zZXMg
dGhlIHJhY2UgdG8gdGhlIGNsZWFyIG9yIGtlZXBzIHRoZSBjb25uZWN0aW9uCmFsaXZlIHVudGls
IHRoZSBub3RpZmljYXRpb24gd29yayByZWxlYXNlcyBpdC4gIFRyYW5zZmVyIHRoZSByZWZlcmVu
Y2UKdG8gdGhlIHdvcmsgaXRlbSBhbmQgcmVsZWFzZSBpdCBvbiBhbGxvY2F0aW9uIGZhaWx1cmVz
LgoKRml4ZXM6IGIwMDMwODZkNzY5NiAoImtzbWJkOiBmaXggTlVMTC1kZXJlZiBvZiBvcGluZm8t
PmNvbm4gaW4gb3Bsb2NrL2xlYXNlIGJyZWFrIG5vdGlmaWVycyIpCkNjOiBzdGFibGVAdmdlci5r
ZXJuZWwub3JnClNpZ25lZC1vZmYtYnk6IEFiZGlmYXRhaCBTdXJ1dXIgPHN1cnV1cmlzbUBnbWFp
bC5jb20+Ci0tLQp2MzoKLSBEcm9wIHRoZSBpbm9kZSByZWZlcmVuY2UgaGVsZCBieSB0aGUgb3Bs
b2NrX2luZm8gKHYyJ3Mgb19jaSk6CiAgaG9sZGluZyBtX2NvdW50IHBhc3QgdGhlIGxhc3QgY2xv
c2UgYnJva2UgZGVsZXRlLW9uLWNsb3NlLCBzaW5jZQogIF9fa3NtYmRfaW5vZGVfY2xvc2UoKSBv
bmx5IHByb21vdGVzIFNfREVMX09OX0NMUyBhbmQgdW5saW5rcyB3aGVuCiAgdGhlIGNsb3NlIGRy
b3BzIG1fY291bnQgdG8gemVybyAocmV2aWV3IGZyb20gTmFtamFlIEplb24pLgotIFBhc3MgdGhl
IGNhbGxlcidzIGlub2RlLCBwaW5uZWQgZm9yIHRoZSBkdXJhdGlvbiBvZiB0aGUgY2FsbCwgaW50
bwogIHRoZSBicmVhayBhbmQgbm90aWZpY2F0aW9uIHBhdGhzIGluc3RlYWQuCi0tLQogZnMvc21i
L3NlcnZlci9vcGxvY2suYyB8IDczICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKy0t
LS0tLS0tLQogMSBmaWxlIGNoYW5nZWQsIDU3IGluc2VydGlvbnMoKyksIDE2IGRlbGV0aW9ucygt
KQoKZGlmZiAtLWdpdCBhL2ZzL3NtYi9zZXJ2ZXIvb3Bsb2NrLmMgYi9mcy9zbWIvc2VydmVyL29w
bG9jay5jCmluZGV4IDU4YWYwZmRkZjM5ZjIuLjFiOGMzNDgyZDFlNGUgMTAwNjQ0Ci0tLSBhL2Zz
L3NtYi9zZXJ2ZXIvb3Bsb2NrLmMKKysrIGIvZnMvc21iL3NlcnZlci9vcGxvY2suYwpAQCAtOTI0
LDMxICs5MjQsNjkgQEAgc3RhdGljIHZvaWQgX19zbWIyX29wbG9ja19icmVha19ub3RpKHN0cnVj
dCB3b3JrX3N0cnVjdCAqd2spCiAJa3NtYmRfY29ubl9wdXQoY29ubik7CiB9CiAKKy8qCisgKiBT
ZWxlY3QgYW5kIHBpbiB0aGUgY29ubmVjdGlvbiB1c2VkIGZvciBhbiBvcGxvY2sgYnJlYWsgYmVm
b3JlIGRvaW5nIGFueQorICogYWxsb2NhdGlvbnMgd2hpY2ggbWF5IHNsZWVwLiAgVGhlIGNhbGxl
ciBvZiBvcGxvY2tfYnJlYWsoKSBob2xkcyBhIGxpdmUKKyAqIHJlZmVyZW5jZSBvbiBjaSAoYSBm
aWxlIGJlaW5nIG9wZW5lZCwgYSBmaWxlIGJlaW5nIG9wZXJhdGVkIG9uLCBvciBhbgorICogZXhw
bGljaXQga3NtYmRfaW5vZGVfbG9va3VwX2xvY2soKSByZWZlcmVuY2UgaW4gdGhlIHBhcmVudCBs
ZWFzZSBicmVhaworICogcGF0aHMpLCBzbyB0aGUgaW5vZGUgY2Fubm90IGJlIGZyZWVkIGR1cmlu
ZyB0aGUgY2FsbCBhbmQgaXRzIGxvY2sgaXMKKyAqIHJlYWNoYWJsZSB3aXRob3V0IGRlcmVmZXJl
bmNpbmcgb3BpbmZvLT5vX2ZwLCB3aGljaCBpcyBub3QgcGlubmVkIGJ5CisgKiB0aGUgb3Bsb2Nr
IHJlZmVyZW5jZSBhbmQgbWF5IGJlIGZyZWVkIGJ5IGEgY29uY3VycmVudCBjbG9zZS4KKyAqCisg
KiBvcGluZm8tPmNvbm4gaXMgY2xlYXJlZCB1bmRlciBjaS0+bV9sb2NrIGJ5IHNlc3Npb25fZmRf
Y2hlY2soKSB3aGVuIHRoZQorICogZHVyYWJsZSBoYW5kbGUgb3duaW5nIHRoZSBvcGxvY2sgaXMg
ZGlzY29ubmVjdGVkLCByZWFzc2lnbmVkIGJ5CisgKiBrc21iZF9yZW9wZW5fZHVyYWJsZV9mZCgp
IHVuZGVyIHRoZSBzYW1lIGxvY2ssIGFuZCB0aGUgbGFzdAorICoga3NtYmRfY29ubl9wdXQoKSBv
ZiB0aGUgb2xkIGNvbm5lY3Rpb24gZnJlZXMgaXQuICBIb2xkaW5nIHRoZSByZWFkIGxvY2sKKyAq
IGV4Y2x1ZGVzIGJvdGggd3JpdGVycywgc28gdGhlIGNvbm5lY3Rpb24gY2Fubm90IGJlIGZyZWVk
IHdoaWxlIGl0IGlzCisgKiBzZWxlY3RlZC4KKyAqLworc3RhdGljIHN0cnVjdCBrc21iZF9jb25u
ICpzbWIyX29wbG9ja19icmVha19jb25uX2dldChzdHJ1Y3Qgb3Bsb2NrX2luZm8gKm9waW5mbywK
KwkJCQkJCSAgICAgc3RydWN0IGtzbWJkX2lub2RlICpjaSkKK3sKKwlzdHJ1Y3Qga3NtYmRfY29u
biAqY29ubjsKKworCWRvd25fcmVhZCgmY2ktPm1fbG9jayk7CisJY29ubiA9IFJFQURfT05DRShv
cGluZm8tPmNvbm4pOworCWlmIChjb25uICYmICFrc21iZF9jb25uX3JlbGVhc2luZyhjb25uKSkK
KwkJY29ubiA9IGtzbWJkX2Nvbm5fZ2V0KGNvbm4pOworCWVsc2UKKwkJY29ubiA9IE5VTEw7CisJ
dXBfcmVhZCgmY2ktPm1fbG9jayk7CisKKwlyZXR1cm4gY29ubjsKK30KKwogLyoqCiAgKiBzbWIy
X29wbG9ja19icmVha19ub3RpKCkgLSBzZW5kIHNtYjIgZXhjbHVzaXZlL2JhdGNoIHRvIGxldmVs
MiBvcGxvY2sKICAqCQlicmVhayBjb21tYW5kIGZyb20gc2VydmVyIHRvIGNsaWVudAogICogQG9w
aW5mbzoJCW9wbG9jayBpbmZvIG9iamVjdAorICogQGNpOgkJaW5vZGUgb3duaW5nIHRoZSBicmVh
ayB0YXJnZXQncyBvcGxvY2sgbGlzdCwgcGlubmVkIGJ5CisgKgkJdGhlIGNhbGxlcgogICoKICAq
IFJldHVybjogICAgICAwIG9uIHN1Y2Nlc3MsIG90aGVyd2lzZSBlcnJvcgogICovCi1zdGF0aWMg
aW50IHNtYjJfb3Bsb2NrX2JyZWFrX25vdGkoc3RydWN0IG9wbG9ja19pbmZvICpvcGluZm8pCitz
dGF0aWMgaW50IHNtYjJfb3Bsb2NrX2JyZWFrX25vdGkoc3RydWN0IG9wbG9ja19pbmZvICpvcGlu
Zm8sCisJCQkJICBzdHJ1Y3Qga3NtYmRfaW5vZGUgKmNpKQogewogCXN0cnVjdCBrc21iZF9jb25u
ICpjb25uOwogCXN0cnVjdCBvcGxvY2tfYnJlYWtfaW5mbyAqYnJfaW5mbzsKIAlpbnQgcmV0ID0g
MDsKIAlzdHJ1Y3Qga3NtYmRfd29yayAqd29yazsKIAotCWNvbm4gPSBSRUFEX09OQ0Uob3BpbmZv
LT5jb25uKTsKKwljb25uID0gc21iMl9vcGxvY2tfYnJlYWtfY29ubl9nZXQob3BpbmZvLCBjaSk7
CiAJaWYgKCFjb25uKQogCQlyZXR1cm4ga3NtYmRfaW52YWxpZGF0ZV9kdXJhYmxlX2ZkKG9waW5m
by0+ZmlkKTsKIAogCXdvcmsgPSBrc21iZF9hbGxvY193b3JrX3N0cnVjdCgpOwotCWlmICghd29y
aykKKwlpZiAoIXdvcmspIHsKKwkJa3NtYmRfY29ubl9wdXQoY29ubik7CiAJCXJldHVybiAtRU5P
TUVNOworCX0KIAogCWJyX2luZm8gPSBrbWFsbG9jX29iaihzdHJ1Y3Qgb3Bsb2NrX2JyZWFrX2lu
Zm8sIEtTTUJEX0RFRkFVTFRfR0ZQKTsKIAlpZiAoIWJyX2luZm8pIHsKIAkJa3NtYmRfZnJlZV93
b3JrX3N0cnVjdCh3b3JrKTsKKwkJa3NtYmRfY29ubl9wdXQoY29ubik7CiAJCXJldHVybiAtRU5P
TUVNOwogCX0KIApAQCAtOTU3LDcgKzk5NSw4IEBAIHN0YXRpYyBpbnQgc21iMl9vcGxvY2tfYnJl
YWtfbm90aShzdHJ1Y3Qgb3Bsb2NrX2luZm8gKm9waW5mbykKIAlicl9pbmZvLT5vcGVuX3RydW5j
ID0gb3BpbmZvLT5vcGVuX3RydW5jOwogCiAJd29yay0+cmVxdWVzdF9idWYgPSAoY2hhciAqKWJy
X2luZm87Ci0Jd29yay0+Y29ubiA9IGtzbWJkX2Nvbm5fZ2V0KGNvbm4pOworCS8qIFRyYW5zZmVy
IHRoZSByZWZlcmVuY2UgYWNxdWlyZWQgYnkgc21iMl9vcGxvY2tfYnJlYWtfY29ubl9nZXQoKS4g
Ki8KKwl3b3JrLT5jb25uID0gY29ubjsKIAl3b3JrLT5zZXNzID0gb3BpbmZvLT5zZXNzOwogCiAJ
a3NtYmRfY29ubl9yX2NvdW50X2luYyhjb25uKTsKQEAgLTExNTQsOSArMTE5Myw5IEBAIHN0YXRp
YyB2b2lkIHdhaXRfbGVhc2VfYnJlYWtpbmcoc3RydWN0IG9wbG9ja19pbmZvICpvcGluZm8pCiAJ
fQogfQogCi1zdGF0aWMgaW50IG9wbG9ja19icmVhayhzdHJ1Y3Qgb3Bsb2NrX2luZm8gKmJya19v
cGluZm8sIGludCByZXFfb3BfbGV2ZWwsCi0JCQlzdHJ1Y3Qga3NtYmRfd29yayAqaW5fd29yaywg
Ym9vbCBzaGFyZV9icmVhaywKLQkJCWJvb2wgc3luY19sZWFzZV9icmVhaykKK3N0YXRpYyBpbnQg
b3Bsb2NrX2JyZWFrKHN0cnVjdCBvcGxvY2tfaW5mbyAqYnJrX29waW5mbywgc3RydWN0IGtzbWJk
X2lub2RlICpjaSwKKwkJCWludCByZXFfb3BfbGV2ZWwsIHN0cnVjdCBrc21iZF93b3JrICppbl93
b3JrLAorCQkJYm9vbCBzaGFyZV9icmVhaywgYm9vbCBzeW5jX2xlYXNlX2JyZWFrKQogewogCWlu
dCBlcnIgPSAwOwogCWJvb2wgc2VudF9pbnRlcmltID0gZmFsc2U7CkBAIC0xMjk4LDcgKzEzMzcs
NyBAQCBzdGF0aWMgaW50IG9wbG9ja19icmVhayhzdHJ1Y3Qgb3Bsb2NrX2luZm8gKmJya19vcGlu
Zm8sIGludCByZXFfb3BfbGV2ZWwsCiAJCX0KIAl9CiAKLQllcnIgPSBzbWIyX29wbG9ja19icmVh
a19ub3RpKGJya19vcGluZm8pOworCWVyciA9IHNtYjJfb3Bsb2NrX2JyZWFrX25vdGkoYnJrX29w
aW5mbywgY2kpOwogCiAJa3NtYmRfZGVidWcoT1BMT0NLLCAib3Bsb2NrIGdyYW50ZWQgPSAlZFxu
IiwgYnJrX29waW5mby0+bGV2ZWwpOwogCWlmIChicmtfb3BpbmZvLT5vcF9zdGF0ZSA9PSBPUExP
Q0tfQ0xPU0lORykKQEAgLTEzMjYsMTMgKzEzNjUsMTQgQEAgc3RhdGljIGludCBvcGxvY2tfYnJl
YWtfYWRkKHN0cnVjdCBsaXN0X2hlYWQgKmhlYWQsIHN0cnVjdCBvcGxvY2tfaW5mbyAqb3BpbmZv
KQogCXJldHVybiAwOwogfQogCi1zdGF0aWMgdm9pZCBvcGxvY2tfYnJlYWtfZHJhaW5fbm9uZShz
dHJ1Y3QgbGlzdF9oZWFkICpoZWFkKQorc3RhdGljIHZvaWQgb3Bsb2NrX2JyZWFrX2RyYWluX25v
bmUoc3RydWN0IGxpc3RfaGVhZCAqaGVhZCwKKwkJCQkgICAgc3RydWN0IGtzbWJkX2lub2RlICpj
aSkKIHsKIAlzdHJ1Y3Qgb3Bsb2NrX2JyZWFrX2VudHJ5ICplbnQsICp0bXA7CiAKIAlsaXN0X2Zv
cl9lYWNoX2VudHJ5X3NhZmUoZW50LCB0bXAsIGhlYWQsIGxpc3QpIHsKLQkJb3Bsb2NrX2JyZWFr
KGVudC0+b3BpbmZvLCBTTUIyX09QTE9DS19MRVZFTF9OT05FLCBOVUxMLCBmYWxzZSwKLQkJCSAg
ICAgZmFsc2UpOworCQlvcGxvY2tfYnJlYWsoZW50LT5vcGluZm8sIGNpLCBTTUIyX09QTE9DS19M
RVZFTF9OT05FLCBOVUxMLAorCQkJICAgICBmYWxzZSwgZmFsc2UpOwogCQlsaXN0X2RlbCgmZW50
LT5saXN0KTsKIAkJb3BpbmZvX3B1dChlbnQtPm9waW5mbyk7CiAJCWtmcmVlKGVudCk7CkBAIC0x
NDgxLDcgKzE1MjEsNyBAQCB2b2lkIHNtYl9zZW5kX3BhcmVudF9sZWFzZV9icmVha19ub3RpKHN0
cnVjdCBrc21iZF9maWxlICpmcCwKIAl9CiAJdXBfcmVhZCgmcF9jaS0+bV9sb2NrKTsKIAotCW9w
bG9ja19icmVha19kcmFpbl9ub25lKCZicmtfbGlzdCk7CisJb3Bsb2NrX2JyZWFrX2RyYWluX25v
bmUoJmJya19saXN0LCBwX2NpKTsKIAogCWtzbWJkX2lub2RlX3B1dChwX2NpKTsKIH0KQEAgLTE1
MjUsNyArMTU2NSw3IEBAIHZvaWQgc21iX2xhenlfcGFyZW50X2xlYXNlX2JyZWFrX2Nsb3NlKHN0
cnVjdCBrc21iZF9maWxlICpmcCkKIAl9CiAJdXBfcmVhZCgmcF9jaS0+bV9sb2NrKTsKIAotCW9w
bG9ja19icmVha19kcmFpbl9ub25lKCZicmtfbGlzdCk7CisJb3Bsb2NrX2JyZWFrX2RyYWluX25v
bmUoJmJya19saXN0LCBwX2NpKTsKIAogCWtzbWJkX2lub2RlX3B1dChwX2NpKTsKIH0KQEAgLTE2
NjUsNyArMTcwNSw3IEBAIGludCBzbWJfZ3JhbnRfb3Bsb2NrKHN0cnVjdCBrc21iZF93b3JrICp3
b3JrLCBpbnQgcmVxX29wX2xldmVsLCB1NjQgcGlkLAogCXByZXZfZHVyYWJsZV9kZXRhY2hlZCA9
IHByZXZfb3Bfc25hcHNob3QuZHVyYWJsZV9kZXRhY2hlZDsKIAlwcmV2X2ZpZCA9IHByZXZfb3Bf
c25hcHNob3QuZmlkOwogCi0JZXJyID0gb3Bsb2NrX2JyZWFrKHByZXZfb3BpbmZvLCBicmVha19s
ZXZlbCwgd29yaywKKwllcnIgPSBvcGxvY2tfYnJlYWsocHJldl9vcGluZm8sIGNpLCBicmVha19s
ZXZlbCwgd29yaywKIAkJCSAgIHNoYXJlX3JldCA8IDAgJiYgcHJldl9vcGluZm8tPmlzX2xlYXNl
LCBmYWxzZSk7CiAJaWYgKHByZXZfZHVyYWJsZV9kZXRhY2hlZCB8fCAocHJldl9kdXJhYmxlX29w
ZW4gJiYgZXJyID09IC1FTk9FTlQpKQogCQlrc21iZF9pbnZhbGlkYXRlX2R1cmFibGVfZmQocHJl
dl9maWQpOwpAQCAtMTc3MSw3ICsxODExLDggQEAgc3RhdGljIGJvb2wgc21iX2JyZWFrX2FsbF93
cml0ZV9vcGxvY2soc3RydWN0IGtzbWJkX3dvcmsgKndvcmssCiAJfQogCiAJYnJrX29waW5mby0+
b3Blbl90cnVuYyA9IGlzX3RydW5jOwotCW9wbG9ja19icmVhayhicmtfb3BpbmZvLCBTTUIyX09Q
TE9DS19MRVZFTF9JSSwgd29yaywgZmFsc2UsIGZhbHNlKTsKKwlvcGxvY2tfYnJlYWsoYnJrX29w
aW5mbywgZnAtPmZfY2ksIFNNQjJfT1BMT0NLX0xFVkVMX0lJLCB3b3JrLCBmYWxzZSwKKwkJICAg
ICBmYWxzZSk7CiAJc2VudF9icmVhayA9IHRydWU7CiAJb3BpbmZvX3B1dChicmtfb3BpbmZvKTsK
IApAQCAtMTg2Myw3ICsxOTA0LDcgQEAgc3RhdGljIHZvaWQgX19zbWJfYnJlYWtfYWxsX2xldklJ
X29wbG9jayhzdHJ1Y3Qga3NtYmRfd29yayAqd29yaywKIAkJCQlicmtfb3AtPm9wX3N0YXRlID0g
T1BMT0NLX1NUQVRFX05PTkU7CiAJCQlzcGluX3VubG9jaygmYnJrX29wLT5zdGF0ZV9sb2NrKTsK
IAkJfSBlbHNlIHsKLQkJCW9wbG9ja19icmVhayhicmtfb3AsCisJCQlvcGxvY2tfYnJlYWsoYnJr
X29wLCBjaSwKIAkJCQkgICAgIGJya19vcC0+aXNfbGVhc2UgJiYgIWlzX3RydW5jID8KIAkJCQkg
ICAgIFNNQjJfT1BMT0NLX0xFVkVMX0lJIDogU01CMl9PUExPQ0tfTEVWRUxfTk9ORSwKIAkJCQkg
ICAgIHNlbmRfaW50ZXJpbSAmJiAhc2VudF9pbnRlcmltID8gd29yayA6IE5VTEwsCi0tIAoyLjUz
LjAKCg==
--000000000000c49ce8065a31aeee--
