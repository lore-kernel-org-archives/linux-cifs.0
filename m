From: Steve French <smfrench@gmail.com>
Subject: Re: [PATCH] cifs: check kzalloc return
Date: Thu, 20 Dec 2018 23:53:04 -0600
Message-ID: <CAH2r5mtrgq-tiSvLrc3sD_Op1HD0OFz2xOMywPoN=iu2nVShrQ@mail.gmail.com>
References: <1545150439-26055-1-git-send-email-hofrat@osadl.org>
 <4db484684a6e9b096c7fdf57673fd208d1c4005a.camel@perches.com>
 <20181219072250.GA18501@osadl.at> <6ef8274c8fc7adb7903cf3874fbab1098881ed4c.camel@perches.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="0000000000000f081a057d81ddf8"
Cc: Nicholas Mc Guire <der.herr@hofr.at>,
        Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Nicholas Mc Guire <hofrat@osadl.org>
To: Joe Perches <joe@perches.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <6ef8274c8fc7adb7903cf3874fbab1098881ed4c.camel@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

--0000000000000f081a057d81ddf8
Content-Type: text/plain; charset="UTF-8"

Updated the patch with Joe's signed off and Nicholas's reviewed-by and
pushed to cifs-2.6.git for-next

See attached.

On Wed, Dec 19, 2018 at 4:58 AM Joe Perches via samba-technical
<samba-technical@lists.samba.org> wrote:
>
> On Wed, 2018-12-19 at 08:22 +0100, Nicholas Mc Guire wrote:
> > On Tue, Dec 18, 2018 at 09:33:58AM -0800, Joe Perches wrote:
> > > On Tue, 2018-12-18 at 17:27 +0100, Nicholas Mc Guire wrote:
> > > > kzalloc can return NULL so a check is needed. While there is a
> > > > check for ret_buf there is no check for the allocation of
> > > > ret_buf->crfid.fid - this check is thus added. Both call-sites
> > > > of tconInfoAlloc() check for NULL return of tconInfoAlloc()
> > > > so returning NULL on failure of kzalloc() here seems appropriate.
> > > > As the kzalloc() is the only thing here that can fail it is
> > > > moved to the beginning so as not to initialize other resources
> > > > on failure of kzalloc.
> > > >
> > > Perhaps use a more common style by returning early on the
> > > first possible failure too so the block can be unindented.
> []
> > > yup the restructured cleanup would be the better way to go
> >
> > rather than making this two patches I guess it would be the
> > best to just skip the intermediate kzalloc only cleanup -
> > atleast I see little value in that intermediat step - so
> > could you take care of the kzalloc() in your refactoring
> > please ?
>
> I did that in the patch I proposed, which is trivial.
> If you want to take it, please do.
>
> If you want a sign-off:
>
> Signed-off-by: Joe Perches <joe@perches.com>
>
> > > diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
> []
> > > @@ -111,21 +111,27 @@ struct cifs_tcon *
> > >  tconInfoAlloc(void)
> > >  {
> > >     struct cifs_tcon *ret_buf;
> > > -   ret_buf = kzalloc(sizeof(struct cifs_tcon), GFP_KERNEL);
> > > -   if (ret_buf) {
> > > -           atomic_inc(&tconInfoAllocCount);
> > > -           ret_buf->tidStatus = CifsNew;
> > > -           ++ret_buf->tc_count;
> > > -           INIT_LIST_HEAD(&ret_buf->openFileList);
> > > -           INIT_LIST_HEAD(&ret_buf->tcon_list);
> > > -           spin_lock_init(&ret_buf->open_file_lock);
> > > -           mutex_init(&ret_buf->crfid.fid_mutex);
> > > -           ret_buf->crfid.fid = kzalloc(sizeof(struct cifs_fid),
> > > -                                        GFP_KERNEL);
> > > -           spin_lock_init(&ret_buf->stat_lock);
> > > -           atomic_set(&ret_buf->num_local_opens, 0);
> > > -           atomic_set(&ret_buf->num_remote_opens, 0);
> > > +
> > > +   ret_buf = kzalloc(sizeof(*ret_buf), GFP_KERNEL);
> > > +   if (!ret_buf)
> > > +           return NULL;
> > > +   ret_buf->crfid.fid = kzalloc(sizeof(*ret_buf->crfid.fid), GFP_KERNEL);
> > > +   if (!ret_buf->crfid.fid) {
> > > +           kfree(ret_buf);
> > > +           return NULL;
> > >     }
> > > +
> > > +   atomic_inc(&tconInfoAllocCount);
> > > +   ret_buf->tidStatus = CifsNew;
> > > +   ++ret_buf->tc_count;
> > > +   INIT_LIST_HEAD(&ret_buf->openFileList);
> > > +   INIT_LIST_HEAD(&ret_buf->tcon_list);
> > > +   spin_lock_init(&ret_buf->open_file_lock);
> > > +   mutex_init(&ret_buf->crfid.fid_mutex);
> > > +   spin_lock_init(&ret_buf->stat_lock);
> > > +   atomic_set(&ret_buf->num_local_opens, 0);
> > > +   atomic_set(&ret_buf->num_remote_opens, 0);
> > > +
> > >     return ret_buf;
> > >  }
> > >
>
>
>


-- 
Thanks,

Steve

--0000000000000f081a057d81ddf8
Content-Type: text/x-patch; charset="US-ASCII"; name="0001-cifs-check-kzalloc-return.patch"
Content-Disposition: attachment;
	filename="0001-cifs-check-kzalloc-return.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_jpxmc8db0>
X-Attachment-Id: f_jpxmc8db0

RnJvbSA2ODdmOTgzZjQ5ZDgwMDM3YmVlMDEyNWY0MzFmOGUwMjQzYzdhYjc3IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBKb2UgUGVyY2hlcyA8am9lQHBlcmNoZXMuY29tPgpEYXRlOiBU
aHUsIDIwIERlYyAyMDE4IDIzOjUwOjQ4IC0wNjAwClN1YmplY3Q6IFtQQVRDSF0gY2lmczogY2hl
Y2sga3phbGxvYyByZXR1cm4KCmt6YWxsb2MgY2FuIHJldHVybiBOVUxMIHNvIGFuIGFkZGl0aW9u
YWwgY2hlY2sgaXMgbmVlZGVkLiBXaGlsZSB0aGVyZQppcyBhIGNoZWNrIGZvciByZXRfYnVmIHRo
ZXJlIGlzIG5vIGNoZWNrIGZvciB0aGUgYWxsb2NhdGlvbiBvZgpyZXRfYnVmLT5jcmZpZC5maWQg
LSB0aGlzIGNoZWNrIGlzIHRodXMgYWRkZWQuIEJvdGggY2FsbC1zaXRlcwpvZiB0Y29uSW5mb0Fs
bG9jKCkgY2hlY2sgZm9yIE5VTEwgcmV0dXJuIG9mIHRjb25JbmZvQWxsb2MoKQpzbyByZXR1cm5p
bmcgTlVMTCBvbiBmYWlsdXJlIG9mIGt6YWxsb2MoKSBoZXJlIHNlZW1zIGFwcHJvcHJpYXRlLgpB
cyB0aGUga3phbGxvYygpIGlzIHRoZSBvbmx5IHRoaW5nIGhlcmUgdGhhdCBjYW4gZmFpbCBpdCBp
cwptb3ZlZCB0byB0aGUgYmVnaW5uaW5nIHNvIGFzIG5vdCB0byBpbml0aWFsaXplIG90aGVyIHJl
c291cmNlcwpvbiBmYWlsdXJlIG9mIGt6YWxsb2MuCgpGaXhlczogM2Q0ZWY5YTE1MzQzICgic21i
MzogZml4IHJlZHVuZGFudCBvcGVucyBvbiByb290IikKLS0tCgpQcm9ibGVtIGxvY2F0ZWQgd2l0
aCBhbiBleHBlcmltZW50YWwgY29jY2luZWxsZSBzY3JpcHQKCldoaWxlIGF0IGl0IG1ha2UgY2hl
Y2twYXRjaCBoYXBweSBieSB1c2luZyAqcmV0X2J1Zi0+Y3JmaWQuZmlkCnJhdGhlciB0aGFuIHN0
cnVjdCBjaWZzX2ZpZC4KClNpZ25lZC1vZmYtYnk6IEpvZSBQZXJjaGVzIDxqb2VAcGVyY2hlcy5j
b20+ClJlcG9ydGVkLWJ5OiBOaWNob2xhcyBNYyBHdWlyZSA8aG9mcmF0QG9zYWRsLm9yZz4KUmV2
aWV3ZWQtYnk6IE5pY2hvbGFzIE1jIEd1aXJlIDxob2ZyYXRAb3NhZGwub3JnPgotLS0KIGZzL2Np
ZnMvbWlzYy5jIHwgMzQgKysrKysrKysrKysrKysrKysrKystLS0tLS0tLS0tLS0tLQogMSBmaWxl
IGNoYW5nZWQsIDIwIGluc2VydGlvbnMoKyksIDE0IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBh
L2ZzL2NpZnMvbWlzYy5jIGIvZnMvY2lmcy9taXNjLmMKaW5kZXggMTEzOTgwZGJhNGQ4Li5iZWUy
MDMwNTViMzAgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvbWlzYy5jCisrKyBiL2ZzL2NpZnMvbWlzYy5j
CkBAIC0xMTEsMjEgKzExMSwyNyBAQCBzdHJ1Y3QgY2lmc190Y29uICoKIHRjb25JbmZvQWxsb2Mo
dm9pZCkKIHsKIAlzdHJ1Y3QgY2lmc190Y29uICpyZXRfYnVmOwotCXJldF9idWYgPSBremFsbG9j
KHNpemVvZihzdHJ1Y3QgY2lmc190Y29uKSwgR0ZQX0tFUk5FTCk7Ci0JaWYgKHJldF9idWYpIHsK
LQkJYXRvbWljX2luYygmdGNvbkluZm9BbGxvY0NvdW50KTsKLQkJcmV0X2J1Zi0+dGlkU3RhdHVz
ID0gQ2lmc05ldzsKLQkJKytyZXRfYnVmLT50Y19jb3VudDsKLQkJSU5JVF9MSVNUX0hFQUQoJnJl
dF9idWYtPm9wZW5GaWxlTGlzdCk7Ci0JCUlOSVRfTElTVF9IRUFEKCZyZXRfYnVmLT50Y29uX2xp
c3QpOwotCQlzcGluX2xvY2tfaW5pdCgmcmV0X2J1Zi0+b3Blbl9maWxlX2xvY2spOwotCQltdXRl
eF9pbml0KCZyZXRfYnVmLT5jcmZpZC5maWRfbXV0ZXgpOwotCQlyZXRfYnVmLT5jcmZpZC5maWQg
PSBremFsbG9jKHNpemVvZihzdHJ1Y3QgY2lmc19maWQpLAotCQkJCQkgICAgIEdGUF9LRVJORUwp
OwotCQlzcGluX2xvY2tfaW5pdCgmcmV0X2J1Zi0+c3RhdF9sb2NrKTsKLQkJYXRvbWljX3NldCgm
cmV0X2J1Zi0+bnVtX2xvY2FsX29wZW5zLCAwKTsKLQkJYXRvbWljX3NldCgmcmV0X2J1Zi0+bnVt
X3JlbW90ZV9vcGVucywgMCk7CisKKwlyZXRfYnVmID0ga3phbGxvYyhzaXplb2YoKnJldF9idWYp
LCBHRlBfS0VSTkVMKTsKKwlpZiAoIXJldF9idWYpCisJCXJldHVybiBOVUxMOworCXJldF9idWYt
PmNyZmlkLmZpZCA9IGt6YWxsb2Moc2l6ZW9mKCpyZXRfYnVmLT5jcmZpZC5maWQpLCBHRlBfS0VS
TkVMKTsKKwlpZiAoIXJldF9idWYtPmNyZmlkLmZpZCkgeworCQlrZnJlZShyZXRfYnVmKTsKKwkJ
cmV0dXJuIE5VTEw7CiAJfQorCisJYXRvbWljX2luYygmdGNvbkluZm9BbGxvY0NvdW50KTsKKwly
ZXRfYnVmLT50aWRTdGF0dXMgPSBDaWZzTmV3OworCSsrcmV0X2J1Zi0+dGNfY291bnQ7CisJSU5J
VF9MSVNUX0hFQUQoJnJldF9idWYtPm9wZW5GaWxlTGlzdCk7CisJSU5JVF9MSVNUX0hFQUQoJnJl
dF9idWYtPnRjb25fbGlzdCk7CisJc3Bpbl9sb2NrX2luaXQoJnJldF9idWYtPm9wZW5fZmlsZV9s
b2NrKTsKKwltdXRleF9pbml0KCZyZXRfYnVmLT5jcmZpZC5maWRfbXV0ZXgpOworCXNwaW5fbG9j
a19pbml0KCZyZXRfYnVmLT5zdGF0X2xvY2spOworCWF0b21pY19zZXQoJnJldF9idWYtPm51bV9s
b2NhbF9vcGVucywgMCk7CisJYXRvbWljX3NldCgmcmV0X2J1Zi0+bnVtX3JlbW90ZV9vcGVucywg
MCk7CisKIAlyZXR1cm4gcmV0X2J1ZjsKIH0KIAotLSAKMi4xNy4xCgo=
--0000000000000f081a057d81ddf8--
