From: Steve French <smfrench@gmail.com>
Subject: Re: [PATCH] cifs: dir: fix memory leak in cifs_mknod
Date: Fri, 20 Apr 2018 12:37:32 -0500
Message-ID: <CAH2r5mtYQujfeEUpEiE557o3YccD9QwWCTLCJFbBoF7zbYcggQ@mail.gmail.com>
References: <20180420131919.GA1766@embeddedor.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="001a11469b8ae4cc20056a4b251f"
Cc: Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors <kernel-janitors@vger.kernel.org>
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Colin King <colin.king@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180420131919.GA1766@embeddedor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

--001a11469b8ae4cc20056a4b251f
Content-Type: text/plain; charset="UTF-8"

I noticed a similar problem with the tcon link leak on that (which
Colin and Gustavo pointed out - thank you!) but also in another return
statement, so updated the original patch of Ronnie's merging the fixes

https://git.samba.org/sfrench/cifs-2.6.git/?p=sfrench/cifs-2.6.git;a=commit;h=167bc5de08dc97695f9d5c7069c3e69f409ff80b


Let me know if you see any problems with it.

On Fri, Apr 20, 2018 at 8:19 AM, Gustavo A. R. Silva
<gustavo@embeddedor.com> wrote:
> Free allocated memory for full_path and xid before return.
>
> Addresses-Coverity-ID: 1468029 ("Resource leak")
> Fixes: 49162bfde140 ("cifs: do not allow creating sockets except with
> SMB1 posix exensions")
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> ---
>  fs/cifs/dir.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
> index f0a759d..71e32d9 100644
> --- a/fs/cifs/dir.c
> +++ b/fs/cifs/dir.c
> @@ -684,8 +684,11 @@ int cifs_mknod(struct inode *inode, struct dentry *direntry, umode_t mode,
>                 goto mknod_out;
>         }
>
> -       if (!S_ISCHR(mode) && !S_ISBLK(mode))
> +       if (!S_ISCHR(mode) && !S_ISBLK(mode)) {
> +               kfree(full_path);
> +               free_xid(xid);
>                 return -EPERM;
> +       }
>
>         if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UNX_EMUL))
>                 goto mknod_out;
> --
> 2.7.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve

--001a11469b8ae4cc20056a4b251f
Content-Type: text/x-patch; charset="US-ASCII";
	name="0001-cifs-do-not-allow-creating-sockets-except-with-SMB1-.patch"
Content-Disposition: attachment;
	filename="0001-cifs-do-not-allow-creating-sockets-except-with-SMB1-.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_jg88jr3o0

RnJvbSAxNjdiYzVkZTA4ZGM5NzY5NWY5ZDVjNzA2OWMzZTY5ZjQwOWZmODBiIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHNtZnJlbmNoQGdtYWlsLmNvbT4KRGF0
ZTogRnJpLCAyMCBBcHIgMjAxOCAxMjoxOTowNyAtMDUwMApTdWJqZWN0OiBbUEFUQ0ggMS8yXSBj
aWZzOiBkbyBub3QgYWxsb3cgY3JlYXRpbmcgc29ja2V0cyBleGNlcHQgd2l0aCBTTUIxCiBwb3Np
eCBleGVuc2lvbnMKClJIQlo6IDE0NTMxMjMKClNpbmNlIGF0IGxlYXN0IHRoZSAzLjEwIGtlcm5l
bCBhbmQgbGlrZWx5IGEgbG90IGVhcmxpZXIgd2UgaGF2ZQpub3QgYmVlbiBhYmxlIHRvIGNyZWF0
ZSB1bml4IGRvbWFpbiBzb2NrZXRzIGluIGEgY2lmcyBzaGFyZQp3aGVuIG1vdW50ZWQgdXNpbmcg
dGhlIFNGVSBtb3VudCBvcHRpb24gKGV4Y2VwdCB3aGVuIG1vdW50ZWQKd2l0aCB0aGUgY2lmcyB1
bml4IGV4dGVuc2lvbnMgdG8gU2FtYmEgZS5nLikKVHJ5aW5nIHRvIGNyZWF0ZSBhIHNvY2tldCwg
Zm9yIGV4YW1wbGUgdXNpbmcgdGhlIGFmX3VuaXggY29tbWFuZCBmcm9tCnhmc3Rlc3RzIHdpbGwg
Y2F1c2UgOgpCVUc6IHVuYWJsZSB0byBoYW5kbGUga2VybmVsIE5VTEwgcG9pbnRlciBkZXJlZmVy
ZW5jZSBhdCAwMDAwMDAwMAowMDAwMDA0MAoKU2luY2Ugbm8gb25lIHVzZXMgb3IgZGVwZW5kcyBv
biBiZWluZyBhYmxlIHRvIGNyZWF0ZSB1bml4IGRvbWFpbnMgc29ja2V0cwpvbiBhIGNpZnMgc2hh
cmUgdGhlIGVhc2llc3QgZml4IHRvIHN0b3AgdGhpcyB2dWxuZXJhYmlsaXR5IGlzIHRvIHNpbXBs
eQpub3QgYWxsb3cgY3JlYXRpb24gb2YgYW55IG90aGVyIHNwZWNpYWwgZmlsZXMgdGhhbiBjaGFy
IG9yIGJsb2NrIGRldmljZXMKd2hlbiBzZnUgaXMgdXNlZC4KCkFkZGVkIHVwZGF0ZSB0byBSb25u
aWUncyBwYXRjaCB0byBoYW5kbGUgYSB0Y29uIGxpbmsgbGVhaywgYW5kCnRvIGFkZHJlc3MgYSBi
dWYgbGVhayBub3RpY2VkIGJ5IEd1c3Rhdm8gYW5kIENvbGluLgoKQ0M6IEd1c3Rhdm8gQS4gUi4g
U2lsdmEgPGd1c3Rhdm9AZW1iZWRkZWRvci5jb20+CkNDOiAgQ29saW4gSWFuIEtpbmcgPGNvbGlu
LmtpbmdAY2Fub25pY2FsLmNvbT4KUmVwb3J0ZWQtYnk6IEVyeXUgR3VhbiA8ZWd1YW5AcmVkaGF0
LmNvbT4KU2lnbmVkLW9mZi1ieTogUm9ubmllIFNhaGxiZXJnIDxsc2FobGJlckByZWRoYXQuY29t
PgpTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVuY2ggPHNtZnJlbmNoQGdtYWlsLmNvbT4KQ2M6IHN0
YWJsZUB2Z2VyLmtlcm5lbC5vcmcKLS0tCiBmcy9jaWZzL2Rpci5jIHwgOSArKysrKy0tLS0KIDEg
ZmlsZSBjaGFuZ2VkLCA1IGluc2VydGlvbnMoKyksIDQgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0
IGEvZnMvY2lmcy9kaXIuYyBiL2ZzL2NpZnMvZGlyLmMKaW5kZXggODFiYTZlMGQ4OGQ4Li45MjU4
NDQzNDMwMzggMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvZGlyLmMKKysrIGIvZnMvY2lmcy9kaXIuYwpA
QCAtNjg0LDYgKzY4NCw5IEBAIGludCBjaWZzX21rbm9kKHN0cnVjdCBpbm9kZSAqaW5vZGUsIHN0
cnVjdCBkZW50cnkgKmRpcmVudHJ5LCB1bW9kZV90IG1vZGUsCiAJCWdvdG8gbWtub2Rfb3V0Owog
CX0KIAorCWlmICghU19JU0NIUihtb2RlKSAmJiAhU19JU0JMSyhtb2RlKSkKKwkJZ290byBta25v
ZF9vdXQ7CisKIAlpZiAoIShjaWZzX3NiLT5tbnRfY2lmc19mbGFncyAmIENJRlNfTU9VTlRfVU5Y
X0VNVUwpKQogCQlnb3RvIG1rbm9kX291dDsKIApAQCAtNjkyLDEwICs2OTUsOCBAQCBpbnQgY2lm
c19ta25vZChzdHJ1Y3QgaW5vZGUgKmlub2RlLCBzdHJ1Y3QgZGVudHJ5ICpkaXJlbnRyeSwgdW1v
ZGVfdCBtb2RlLAogCiAJYnVmID0ga21hbGxvYyhzaXplb2YoRklMRV9BTExfSU5GTyksIEdGUF9L
RVJORUwpOwogCWlmIChidWYgPT0gTlVMTCkgewotCQlrZnJlZShmdWxsX3BhdGgpOwogCQlyYyA9
IC1FTk9NRU07Ci0JCWZyZWVfeGlkKHhpZCk7Ci0JCXJldHVybiByYzsKKwkJZ290byBta25vZF9v
dXQ7CiAJfQogCiAJaWYgKGJhY2t1cF9jcmVkKGNpZnNfc2IpKQpAQCAtNzQyLDcgKzc0Myw3IEBA
IGludCBjaWZzX21rbm9kKHN0cnVjdCBpbm9kZSAqaW5vZGUsIHN0cnVjdCBkZW50cnkgKmRpcmVu
dHJ5LCB1bW9kZV90IG1vZGUsCiAJCXBkZXYtPm1pbm9yID0gY3B1X3RvX2xlNjQoTUlOT1IoZGV2
aWNlX251bWJlcikpOwogCQlyYyA9IHRjb24tPnNlcy0+c2VydmVyLT5vcHMtPnN5bmNfd3JpdGUo
eGlkLCAmZmlkLCAmaW9fcGFybXMsCiAJCQkJCQkJJmJ5dGVzX3dyaXR0ZW4sIGlvdiwgMSk7Ci0J
fSAvKiBlbHNlIGlmIChTX0lTRklGTykgKi8KKwl9CiAJdGNvbi0+c2VzLT5zZXJ2ZXItPm9wcy0+
Y2xvc2UoeGlkLCB0Y29uLCAmZmlkKTsKIAlkX2Ryb3AoZGlyZW50cnkpOwogCi0tIAoyLjE0LjEK
Cg==
--001a11469b8ae4cc20056a4b251f--
