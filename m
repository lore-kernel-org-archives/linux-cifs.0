From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [bug report] Handle mismatched open calls
Date: Fri, 07 Apr 2017 13:18:58 +0100
Message-ID: <1491567538.8010.6.camel@redhat.com>
References: <20170406091021.GA28584@mwanda>
         <1491473227.3042.2.camel@redhat.com> <1491503047.8010.2.camel@redhat.com>
         <20170407082024.GA4420@mwanda>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-7hdEan0OBBLfqlB/CPMC"
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, smfrench <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170407082024.GA4420@mwanda>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>


--=-7hdEan0OBBLfqlB/CPMC
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit

On Fri, 2017-04-07 at 11:20 +0300, Dan Carpenter wrote:
> Sure, that takes care of the static checker warning.  But then I had
> all sorts of style nits to whinge-bucket about which you didn't ask
> for...
> 

Thanks Dan,

I have incorporated all the requested changes into version 7 of the
patch.

Is smatch the only tool you use for static analysis? I am considering
adding it to my own dev process.

Steve, Can you please use this version instead.

Regards,
Sachin Prabhu


> On Thu, Apr 06, 2017 at 07:24:07PM +0100, Sachin Prabhu wrote:
> > diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> > index 9ae695a..131663b 100644
> > --- a/fs/cifs/connect.c
> > +++ b/fs/cifs/connect.c
> > @@ -904,10 +904,19 @@ cifs_demultiplex_thread(void *p)
> >  
> >  		server->lstrp = jiffies;
> >  		if (mid_entry != NULL) {
> > +			if ((mid_entry->mid_flags &
> > MID_WAIT_CANCELLED) &&
> > +			     mid_entry->mid_state ==
> > MID_RESPONSE_RECEIVED &&
> > +					(server->ops-
> > >handle_cancelled_mid))
> 
> Extra parens are not required.  Please align it like this:
> 
> 			if ((mid_entry->mid_flags & MID_WAIT_CANCELLED)
> &&
> 			     mid_entry->mid_state ==
> MID_RESPONSE_RECEIVED &&
> 			     server->ops->handle_cancelled_mid)
> 
> 
> 
> > +				server->ops->handle_cancelled_mid(
> > +							mid_entry-
> > >resp_buf,
> > +							server);
> > +
> >  			if (!mid_entry->multiRsp || mid_entry-
> > >multiEnd)
> >  				mid_entry->callback(mid_entry);
> > -		} else if (!server->ops->is_oplock_break ||
> > -			   !server->ops->is_oplock_break(buf,
> > server)) {
> > +		} else if (server->ops->is_oplock_break &&
> > +			   server->ops->is_oplock_break(buf,
> > server)) {
> > +			cifs_dbg(FYI, "Received oplock break\n");
> > +		} else {
> >  			cifs_dbg(VFS, "No task to wake, unknown
> > frame received! NumMids %d\n",
> >  				 atomic_read(&midCount));
> >  			cifs_dump_mem("Received Data is: ", buf,
> > diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
> > index fd516ea..f50e3ef 100644
> > --- a/fs/cifs/smb2misc.c
> > +++ b/fs/cifs/smb2misc.c
> > @@ -659,3 +659,51 @@ smb2_is_valid_oplock_break(char *buffer,
> > struct TCP_Server_Info *server)
> >  	cifs_dbg(FYI, "Can not process oplock break for non-
> > existent connection\n");
> >  	return false;
> >  }
> > +
> > +void
> > +smb2_cancelled_close_fid(struct work_struct *work)
> > +{
> > +	struct close_cancelled_open *cancelled =
> > container_of(work,
> > +					struct
> > close_cancelled_open, work);
> > +
> > +	cifs_dbg(VFS, "Close unmatched open\n");
> > +
> > +	SMB2_close(0, cancelled->tcon, cancelled-
> > >fid.persistent_fid,
> > +					   cancelled-
> > >fid.volatile_fid);
> 
> Don't right align it.  Do it like this:
> 
> 	SMB2_close(0, cancelled->tcon, cancelled->fid.persistent_fid,
> 		   cancelled->fid.volatile_fid);
> 
> 
> 
> > +	cifs_put_tcon(cancelled->tcon);
> > +	kfree(cancelled);
> > +}
> > +
> > +int
> > +smb2_handle_cancelled_mid(char *buffer, struct TCP_Server_Info
> > *server)
> > +{
> > +	struct smb2_sync_hdr *sync_hdr = get_sync_hdr(buffer);
> > +	struct smb2_create_rsp *rsp = (struct smb2_create_rsp
> > *)buffer;
> > +	struct cifs_tcon *tcon;
> > +	struct close_cancelled_open *cancelled;
> > +
> > +	if ((sync_hdr->Command != SMB2_CREATE) ||
> > +		(sync_hdr->Status != STATUS_SUCCESS))
> 
> No need for extra parens.  Align it like this:
> 
> 	if (sync_hdr->Command != SMB2_CREATE ||
> 	    sync_hdr->Status != STATUS_SUCCESS)
> 		return 0;
> 
> 
> 
> > +		return 0;
> > +
> > +	cancelled = (struct close_cancelled_open *)
> > +			kzalloc(sizeof(struct
> > close_cancelled_open),
> > +				GFP_KERNEL);
> 
> No need to cast kzalloc.  Use sizeof(*cancelled).
> 
> 	cancelled = kzalloc(sizeof(*cancelled), GFP_KERNEL);
> 
> 
> > +	if (!cancelled)
> > +		return -ENOMEM;
> > +
> > +	tcon = smb2_find_smb_tcon(server, sync_hdr->SessionId,
> > +				  sync_hdr->TreeId);
> > +	if (!tcon) {
> > +		kfree(cancelled);
> > +		return -ENOENT;
> > +	}
> > +
> > +	cancelled->fid.persistent_fid = rsp->PersistentFileId;
> > +	cancelled->fid.volatile_fid = rsp->VolatileFileId;
> > +	cancelled->tcon = tcon;
> > +	INIT_WORK(&cancelled->work, smb2_cancelled_close_fid);
> > +	queue_work(cifsiod_wq, &cancelled->work);
> > +
> > +	return 0;
> > +}
> 
> [ snip ]
> 
> > diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
> > index 7c3bb1b..e3c8a9c 100644
> > --- a/fs/cifs/smb2transport.c
> > +++ b/fs/cifs/smb2transport.c
> > @@ -115,23 +115,72 @@ smb3_crypto_shash_allocate(struct
> > TCP_Server_Info *server)
> >  	return 0;
> >  }
> >  
> > -struct cifs_ses *
> > -smb2_find_smb_ses(struct TCP_Server_Info *server, __u64 ses_id)
> > +static struct cifs_ses *
> > +_smb2_find_smb_ses(struct TCP_Server_Info *server, __u64 ses_id)
> 
> Could you name this "locked" or something and get rid of the _
> underscore prefix?
> 
> >  {
> >  	struct cifs_ses *ses;
> >  
> > -	spin_lock(&cifs_tcp_ses_lock);
> >  	list_for_each_entry(ses, &server->smb_ses_list,
> > smb_ses_list) {
> >  		if (ses->Suid != ses_id)
> >  			continue;
> > -		spin_unlock(&cifs_tcp_ses_lock);
> >  		return ses;
> >  	}
> > +
> > +	return NULL;
> > +}
> > +
> > +struct cifs_ses *
> > +smb2_find_smb_ses(struct TCP_Server_Info *server, __u64 ses_id)
> > +{
> > +	struct cifs_ses *ses;
> > +
> > +	spin_lock(&cifs_tcp_ses_lock);
> > +	ses = _smb2_find_smb_ses(server, ses_id);
> >  	spin_unlock(&cifs_tcp_ses_lock);
> >  
> > +	return ses;
> > +}
> > +
> > +static struct cifs_tcon *
> > +_smb2_find_smb_sess_tcon(struct cifs_ses *ses, __u32  tid)
> 
> Just leave out the _ underscore prefix.  This is a static function so
> there aren't that many users and they presumably know the locking
> rules.
> For smb2_find_smb_ses we have a locked and unlocked version of the
> function so it makes sense to put that in the name but here there is
> no need I think.
> 
> > +{
> > +	struct list_head *tmp;
> > +	struct cifs_tcon *tcon;
> > +
> > +	list_for_each(tmp, &ses->tcon_list) {
> > +		tcon = list_entry(tmp, struct cifs_tcon,
> > tcon_list);
> 
> list_for_each_entry()?
> 
> > +		if (tcon->tid != tid)
> > +			continue;
> > +		++tcon->tc_count;
> > +		return tcon;
> > +	}
> > +
> >  	return NULL;
> >  }
> >  
> > +/*
> > + * Obtain tcon corresponding to the tid in the given
> > + * cifs_ses
> > + */
> > +
> > +struct cifs_tcon *
> > +smb2_find_smb_tcon(struct TCP_Server_Info *server, __u64 ses_id,
> > __u32  tid)
> > +{
> > +	struct cifs_ses *ses;
> > +	struct cifs_tcon *tcon;
> > +
> > +	spin_lock(&cifs_tcp_ses_lock);
> > +	ses = _smb2_find_smb_ses(server, ses_id);
> > +	if (!ses) {
> > +		spin_unlock(&cifs_tcp_ses_lock);
> > +		return NULL;
> > +	}
> > +	tcon = _smb2_find_smb_sess_tcon(ses, tid);
> > +	spin_unlock(&cifs_tcp_ses_lock);
> > +
> > +	return tcon;
> > +}
> > +
> >  int
> >  smb2_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info
> > *server)
> >  {
> > @@ -511,6 +560,7 @@ smb2_mid_entry_alloc(const struct smb2_sync_hdr
> > *shdr,
> >  
> >  	atomic_inc(&midCount);
> >  	temp->mid_state = MID_REQUEST_ALLOCATED;
> > +	temp->mid_flags = 0;
> 
> No need.  We already memset() this to zero.
> 
> >  	return temp;
> >  }
> >  
> > diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> > index 526f053..d82a4ae 100644
> > --- a/fs/cifs/transport.c
> > +++ b/fs/cifs/transport.c
> > @@ -752,9 +752,12 @@ cifs_send_recv(const unsigned int xid, struct
> > cifs_ses *ses,
> >  
> >  	rc = wait_for_response(ses->server, midQ);
> >  	if (rc != 0) {
> > +		cifs_dbg(FYI, "Cancelling wait for mid %lu\n",
> > +				(unsigned long)midQ->mid);
> 
> ->mid is u64.  Just do this:
> 
> 		cifs_dbg(FYI, "Cancelling wait for mid %llu\n", midQ-
> >mid);
> 
> 
> >  		send_cancel(ses->server, rqst, midQ);
> >  		spin_lock(&GlobalMid_Lock);
> >  		if (midQ->mid_state == MID_REQUEST_SUBMITTED) {
> > +			midQ->mid_flags |= MID_WAIT_CANCELLED;
> >  			midQ->callback = DeleteMidQEntry;
> >  			spin_unlock(&GlobalMid_Lock);
> >  			add_credits(ses->server, 1, optype);
> 
> regards,
> dan carpenter
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" 
> in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-7hdEan0OBBLfqlB/CPMC
Content-Disposition: attachment; filename="0001-v7-Handle-mismatched-open-calls.patch"
Content-Type: text/x-patch; name="0001-v7-Handle-mismatched-open-calls.patch";
	charset="UTF-8"
Content-Transfer-Encoding: base64

RnJvbSAxOThiOWI5YWUxYjc3ZDFkNzljZjcyYTk0N2QwZWU4OTliYWEzNGI0IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTYWNoaW4gUHJhYmh1IDxzcHJhYmh1QHJlZGhhdC5jb20+CkRh
dGU6IEZyaSwgMyBNYXIgMjAxNyAxNTo0MTozOCAtMDgwMApTdWJqZWN0OiBbUEFUQ0hdIFt2N11I
YW5kbGUgbWlzbWF0Y2hlZCBvcGVuIGNhbGxzCgpBIHNpZ25hbCBjYW4gaW50ZXJydXB0IGEgU2Vu
ZFJlY2VpdmUgY2FsbCB3aGljaCByZXN1bHQgaW4gaW5jb21pbmcKcmVzcG9uc2VzIHRvIHRoZSBj
YWxsIGJlaW5nIGlnbm9yZWQuIFRoaXMgaXMgYSBwcm9ibGVtIGZvciBjYWxscyBzdWNoIGFzCm9w
ZW4gd2hpY2ggcmVzdWx0cyBpbiB0aGUgc3VjY2Vzc2Z1bCByZXNwb25zZSBiZWluZyBpZ25vcmVk
LiBUaGlzCnJlc3VsdHMgaW4gYW4gb3BlbiBmaWxlIHJlc291cmNlIG9uIHRoZSBzZXJ2ZXIuCgpU
aGUgcGF0Y2ggbG9va3MgaW50byByZXNwb25zZXMgd2hpY2ggd2VyZSBjYW5jZWxsZWQgYWZ0ZXIg
YmVpbmcgc2VudCBhbmQKaW4gY2FzZSBvZiBzdWNjZXNzZnVsIG9wZW4gY2xvc2VzIHRoZSBvcGVu
IGZpZHMuCgpGb3IgdGhpcyBwYXRjaCwgdGhlIGNoZWNrIGlzIG9ubHkgZG9uZSBpbiBTZW5kUmVj
ZWl2ZTIoKQoKUkgtYno6IDE0MDMzMTkKClNpZ25lZC1vZmYtYnk6IFNhY2hpbiBQcmFiaHUgPHNw
cmFiaHVAcmVkaGF0LmNvbT4KUmV2aWV3ZWQtYnk6IFBhdmVsIFNoaWxvdnNreSA8cHNoaWxvdkBt
aWNyb3NvZnQuY29tPgpDYzogU3RhYmxlIDxzdGFibGVAdmdlci5rZXJuZWwub3JnPgotLS0KIGZz
L2NpZnMvY2lmc2dsb2IuaCAgICAgIHwgMTEgKysrKysrKysrKwogZnMvY2lmcy9jaWZzcHJvdG8u
aCAgICAgfCAgMyArKy0KIGZzL2NpZnMvY2lmc3NtYi5jICAgICAgIHwgMTEgKysrKysrLS0tLQog
ZnMvY2lmcy9jb25uZWN0LmMgICAgICAgfCAxMyArKysrKysrKysrLS0KIGZzL2NpZnMvc21iMm1p
c2MuYyAgICAgIHwgNDYgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysK
IGZzL2NpZnMvc21iMm9wcy5jICAgICAgIHwgIDggKysrKystLQogZnMvY2lmcy9zbWIycHJvdG8u
aCAgICAgfCAgNyArKysrKysrCiBmcy9jaWZzL3NtYjJ0cmFuc3BvcnQuYyB8IDU1ICsrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKy0tLS0KIGZzL2NpZnMvdHJhbnNw
b3J0LmMgICAgIHwgIDIgKysKIDkgZmlsZXMgY2hhbmdlZCwgMTQzIGluc2VydGlvbnMoKyksIDEz
IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvY2lmc2dsb2IuaCBiL2ZzL2NpZnMv
Y2lmc2dsb2IuaAppbmRleCBjNTY1ZTBkYi4uZDA3ZjEzYSAxMDA2NDQKLS0tIGEvZnMvY2lmcy9j
aWZzZ2xvYi5oCisrKyBiL2ZzL2NpZnMvY2lmc2dsb2IuaApAQCAtMjQzLDYgKzI0Myw3IEBAIHN0
cnVjdCBzbWJfdmVyc2lvbl9vcGVyYXRpb25zIHsKIAkvKiB2ZXJpZnkgdGhlIG1lc3NhZ2UgKi8K
IAlpbnQgKCpjaGVja19tZXNzYWdlKShjaGFyICosIHVuc2lnbmVkIGludCwgc3RydWN0IFRDUF9T
ZXJ2ZXJfSW5mbyAqKTsKIAlib29sICgqaXNfb3Bsb2NrX2JyZWFrKShjaGFyICosIHN0cnVjdCBU
Q1BfU2VydmVyX0luZm8gKik7CisJaW50ICgqaGFuZGxlX2NhbmNlbGxlZF9taWQpKGNoYXIgKiwg
c3RydWN0IFRDUF9TZXJ2ZXJfSW5mbyAqKTsKIAl2b2lkICgqZG93bmdyYWRlX29wbG9jaykoc3Ry
dWN0IFRDUF9TZXJ2ZXJfSW5mbyAqLAogCQkJCQlzdHJ1Y3QgY2lmc0lub2RlSW5mbyAqLCBib29s
KTsKIAkvKiBwcm9jZXNzIHRyYW5zYWN0aW9uMiByZXNwb25zZSAqLwpAQCAtMTM0NCw2ICsxMzQ1
LDcgQEAgc3RydWN0IG1pZF9xX2VudHJ5IHsKIAl2b2lkICpjYWxsYmFja19kYXRhOwkgIC8qIGdl
bmVyYWwgcHVycG9zZSBwb2ludGVyIGZvciBjYWxsYmFjayAqLwogCXZvaWQgKnJlc3BfYnVmOwkJ
LyogcG9pbnRlciB0byByZWNlaXZlZCBTTUIgaGVhZGVyICovCiAJaW50IG1pZF9zdGF0ZTsJLyog
d2lzaCB0aGlzIHdlcmUgZW51bSBidXQgY2FuIG5vdCBwYXNzIHRvIHdhaXRfZXZlbnQgKi8KKwl1
bnNpZ25lZCBpbnQgbWlkX2ZsYWdzOwogCV9fbGUxNiBjb21tYW5kOwkJLyogc21iIGNvbW1hbmQg
Y29kZSAqLwogCWJvb2wgbGFyZ2VfYnVmOjE7CS8qIGlmIHZhbGlkIHJlc3BvbnNlLCBpcyBwb2lu
dGVyIHRvIGxhcmdlIGJ1ZiAqLwogCWJvb2wgbXVsdGlSc3A6MTsJLyogbXVsdGlwbGUgdHJhbnMy
IHJlc3BvbnNlcyBmb3Igb25lIHJlcXVlc3QgICovCkBAIC0xMzUxLDYgKzEzNTMsMTIgQEAgc3Ry
dWN0IG1pZF9xX2VudHJ5IHsKIAlib29sIGRlY3J5cHRlZDoxOwkvKiBkZWNyeXB0ZWQgZW50cnkg
Ki8KIH07CiAKK3N0cnVjdCBjbG9zZV9jYW5jZWxsZWRfb3BlbiB7CisJc3RydWN0IGNpZnNfZmlk
ICAgICAgICAgZmlkOworCXN0cnVjdCBjaWZzX3Rjb24gICAgICAgICp0Y29uOworCXN0cnVjdCB3
b3JrX3N0cnVjdCAgICAgIHdvcms7Cit9OworCiAvKglNYWtlIGNvZGUgaW4gdHJhbnNwb3J0LmMg
YSBsaXR0bGUgY2xlYW5lciBieSBtb3ZpbmcKIAl1cGRhdGUgb2Ygb3B0aW9uYWwgc3RhdHMgaW50
byBmdW5jdGlvbiBiZWxvdyAqLwogI2lmZGVmIENPTkZJR19DSUZTX1NUQVRTMgpAQCAtMTQ4Miw2
ICsxNDkwLDkgQEAgc3RhdGljIGlubGluZSB2b2lkIGZyZWVfZGZzX2luZm9fYXJyYXkoc3RydWN0
IGRmc19pbmZvM19wYXJhbSAqcGFyYW0sCiAjZGVmaW5lICAgTUlEX1JFU1BPTlNFX01BTEZPUk1F
RCAweDEwCiAjZGVmaW5lICAgTUlEX1NIVVRET1dOCQkgMHgyMAogCisvKiBGbGFncyAqLworI2Rl
ZmluZSAgIE1JRF9XQUlUX0NBTkNFTExFRAkgMSAvKiBDYW5jZWxsZWQgd2hpbGUgd2FpdGluZyBm
b3IgcmVzcG9uc2UgKi8KKwogLyogVHlwZXMgb2YgcmVzcG9uc2UgYnVmZmVyIHJldHVybmVkIGZy
b20gU2VuZFJlY2VpdmUyICovCiAjZGVmaW5lICAgQ0lGU19OT19CVUZGRVIgICAgICAgIDAgICAg
LyogUmVzcG9uc2UgYnVmZmVyIG5vdCByZXR1cm5lZCAqLwogI2RlZmluZSAgIENJRlNfU01BTExf
QlVGRkVSICAgICAxCmRpZmYgLS1naXQgYS9mcy9jaWZzL2NpZnNwcm90by5oIGIvZnMvY2lmcy9j
aWZzcHJvdG8uaAppbmRleCA5N2U1ZDIzLi5lYzVlNWU1IDEwMDY0NAotLS0gYS9mcy9jaWZzL2Np
ZnNwcm90by5oCisrKyBiL2ZzL2NpZnMvY2lmc3Byb3RvLmgKQEAgLTc5LDcgKzc5LDggQEAgZXh0
ZXJuIHZvaWQgY2lmc19kZWxldGVfbWlkKHN0cnVjdCBtaWRfcV9lbnRyeSAqbWlkKTsKIGV4dGVy
biB2b2lkIGNpZnNfd2FrZV91cF90YXNrKHN0cnVjdCBtaWRfcV9lbnRyeSAqbWlkKTsKIGV4dGVy
biBpbnQgY2lmc19oYW5kbGVfc3RhbmRhcmQoc3RydWN0IFRDUF9TZXJ2ZXJfSW5mbyAqc2VydmVy
LAogCQkJCXN0cnVjdCBtaWRfcV9lbnRyeSAqbWlkKTsKLWV4dGVybiBpbnQgY2lmc19kaXNjYXJk
X3JlbWFpbmluZ19kYXRhKHN0cnVjdCBUQ1BfU2VydmVyX0luZm8gKnNlcnZlcik7CitleHRlcm4g
aW50IGNpZnNfZGlzY2FyZF9yZW1haW5pbmdfZGF0YShzdHJ1Y3QgVENQX1NlcnZlcl9JbmZvICpz
ZXJ2ZXIsCisJCQkJICAgICAgIGNoYXIgKmJ1Zik7CiBleHRlcm4gaW50IGNpZnNfY2FsbF9hc3lu
YyhzdHJ1Y3QgVENQX1NlcnZlcl9JbmZvICpzZXJ2ZXIsCiAJCQlzdHJ1Y3Qgc21iX3Jxc3QgKnJx
c3QsCiAJCQltaWRfcmVjZWl2ZV90ICpyZWNlaXZlLCBtaWRfY2FsbGJhY2tfdCAqY2FsbGJhY2ss
CmRpZmYgLS1naXQgYS9mcy9jaWZzL2NpZnNzbWIuYyBiL2ZzL2NpZnMvY2lmc3NtYi5jCmluZGV4
IDA2Njk1MDYuLjk2N2I5MjYzIDEwMDY0NAotLS0gYS9mcy9jaWZzL2NpZnNzbWIuYworKysgYi9m
cy9jaWZzL2NpZnNzbWIuYwpAQCAtMTQwMCw5ICsxNDAwLDkgQEAgQ0lGU19vcGVuKGNvbnN0IHVu
c2lnbmVkIGludCB4aWQsIHN0cnVjdCBjaWZzX29wZW5fcGFybXMgKm9wYXJtcywgaW50ICpvcGxv
Y2ssCiAgKiBjdXJyZW50IGJpZ2J1Zi4KICAqLwogaW50Ci1jaWZzX2Rpc2NhcmRfcmVtYWluaW5n
X2RhdGEoc3RydWN0IFRDUF9TZXJ2ZXJfSW5mbyAqc2VydmVyKQorY2lmc19kaXNjYXJkX3JlbWFp
bmluZ19kYXRhKHN0cnVjdCBUQ1BfU2VydmVyX0luZm8gKnNlcnZlciwgY2hhciAqYnVmKQogewot
CXVuc2lnbmVkIGludCByZmNsZW4gPSBnZXRfcmZjMTAwMl9sZW5ndGgoc2VydmVyLT5zbWFsbGJ1
Zik7CisJdW5zaWduZWQgaW50IHJmY2xlbiA9IGdldF9yZmMxMDAyX2xlbmd0aChidWYpOwogCWlu
dCByZW1haW5pbmcgPSByZmNsZW4gKyA0IC0gc2VydmVyLT50b3RhbF9yZWFkOwogCiAJd2hpbGUg
KHJlbWFpbmluZyA+IDApIHsKQEAgLTE0MjYsNyArMTQyNiw3IEBAIGNpZnNfcmVhZHZfZGlzY2Fy
ZChzdHJ1Y3QgVENQX1NlcnZlcl9JbmZvICpzZXJ2ZXIsIHN0cnVjdCBtaWRfcV9lbnRyeSAqbWlk
KQogCWludCBsZW5ndGg7CiAJc3RydWN0IGNpZnNfcmVhZGRhdGEgKnJkYXRhID0gbWlkLT5jYWxs
YmFja19kYXRhOwogCi0JbGVuZ3RoID0gY2lmc19kaXNjYXJkX3JlbWFpbmluZ19kYXRhKHNlcnZl
cik7CisJbGVuZ3RoID0gY2lmc19kaXNjYXJkX3JlbWFpbmluZ19kYXRhKHNlcnZlciwgbWlkLT5y
ZXNwX2J1Zik7CiAJZGVxdWV1ZV9taWQobWlkLCByZGF0YS0+cmVzdWx0KTsKIAlyZXR1cm4gbGVu
Z3RoOwogfQpAQCAtMTQ1OSw3ICsxNDU5LDcgQEAgY2lmc19yZWFkdl9yZWNlaXZlKHN0cnVjdCBU
Q1BfU2VydmVyX0luZm8gKnNlcnZlciwgc3RydWN0IG1pZF9xX2VudHJ5ICptaWQpCiAKIAlpZiAo
c2VydmVyLT5vcHMtPmlzX3N0YXR1c19wZW5kaW5nICYmCiAJICAgIHNlcnZlci0+b3BzLT5pc19z
dGF0dXNfcGVuZGluZyhidWYsIHNlcnZlciwgMCkpIHsKLQkJY2lmc19kaXNjYXJkX3JlbWFpbmlu
Z19kYXRhKHNlcnZlcik7CisJCWNpZnNfZGlzY2FyZF9yZW1haW5pbmdfZGF0YShzZXJ2ZXIsIGJ1
Zik7CiAJCXJldHVybiAtMTsKIAl9CiAKQEAgLTE1MTksNiArMTUxOSw5IEBAIGNpZnNfcmVhZHZf
cmVjZWl2ZShzdHJ1Y3QgVENQX1NlcnZlcl9JbmZvICpzZXJ2ZXIsIHN0cnVjdCBtaWRfcV9lbnRy
eSAqbWlkKQogCWNpZnNfZGJnKEZZSSwgIjA6IGlvdl9iYXNlPSVwIGlvdl9sZW49JXVcbiIsCiAJ
CSByZGF0YS0+aW92WzBdLmlvdl9iYXNlLCBzZXJ2ZXItPnRvdGFsX3JlYWQpOwogCisJbWlkLT5y
ZXNwX2J1ZiA9IHNlcnZlci0+c21hbGxidWY7CisJc2VydmVyLT5zbWFsbGJ1ZiA9IE5VTEw7CisK
IAkvKiBob3cgbXVjaCBkYXRhIGlzIGluIHRoZSByZXNwb25zZT8gKi8KIAlkYXRhX2xlbiA9IHNl
cnZlci0+b3BzLT5yZWFkX2RhdGFfbGVuZ3RoKGJ1Zik7CiAJaWYgKGRhdGFfb2Zmc2V0ICsgZGF0
YV9sZW4gPiBidWZsZW4pIHsKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvY29ubmVjdC5jIGIvZnMvY2lm
cy9jb25uZWN0LmMKaW5kZXggOWFlNjk1YS4uMGM3NTk2YyAxMDA2NDQKLS0tIGEvZnMvY2lmcy9j
b25uZWN0LmMKKysrIGIvZnMvY2lmcy9jb25uZWN0LmMKQEAgLTkwNCwxMCArOTA0LDE5IEBAIGNp
ZnNfZGVtdWx0aXBsZXhfdGhyZWFkKHZvaWQgKnApCiAKIAkJc2VydmVyLT5sc3RycCA9IGppZmZp
ZXM7CiAJCWlmIChtaWRfZW50cnkgIT0gTlVMTCkgeworCQkJaWYgKChtaWRfZW50cnktPm1pZF9m
bGFncyAmIE1JRF9XQUlUX0NBTkNFTExFRCkgJiYKKwkJCSAgICAgbWlkX2VudHJ5LT5taWRfc3Rh
dGUgPT0gTUlEX1JFU1BPTlNFX1JFQ0VJVkVEICYmCisJCQkJCXNlcnZlci0+b3BzLT5oYW5kbGVf
Y2FuY2VsbGVkX21pZCkKKwkJCQlzZXJ2ZXItPm9wcy0+aGFuZGxlX2NhbmNlbGxlZF9taWQoCisJ
CQkJCQkJbWlkX2VudHJ5LT5yZXNwX2J1ZiwKKwkJCQkJCQlzZXJ2ZXIpOworCiAJCQlpZiAoIW1p
ZF9lbnRyeS0+bXVsdGlSc3AgfHwgbWlkX2VudHJ5LT5tdWx0aUVuZCkKIAkJCQltaWRfZW50cnkt
PmNhbGxiYWNrKG1pZF9lbnRyeSk7Ci0JCX0gZWxzZSBpZiAoIXNlcnZlci0+b3BzLT5pc19vcGxv
Y2tfYnJlYWsgfHwKLQkJCSAgICFzZXJ2ZXItPm9wcy0+aXNfb3Bsb2NrX2JyZWFrKGJ1Ziwgc2Vy
dmVyKSkgeworCQl9IGVsc2UgaWYgKHNlcnZlci0+b3BzLT5pc19vcGxvY2tfYnJlYWsgJiYKKwkJ
CSAgIHNlcnZlci0+b3BzLT5pc19vcGxvY2tfYnJlYWsoYnVmLCBzZXJ2ZXIpKSB7CisJCQljaWZz
X2RiZyhGWUksICJSZWNlaXZlZCBvcGxvY2sgYnJlYWtcbiIpOworCQl9IGVsc2UgewogCQkJY2lm
c19kYmcoVkZTLCAiTm8gdGFzayB0byB3YWtlLCB1bmtub3duIGZyYW1lIHJlY2VpdmVkISBOdW1N
aWRzICVkXG4iLAogCQkJCSBhdG9taWNfcmVhZCgmbWlkQ291bnQpKTsKIAkJCWNpZnNfZHVtcF9t
ZW0oIlJlY2VpdmVkIERhdGEgaXM6ICIsIGJ1ZiwKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvc21iMm1p
c2MuYyBiL2ZzL2NpZnMvc21iMm1pc2MuYwppbmRleCBmZDUxNmVhLi4xYTA0YjNhIDEwMDY0NAot
LS0gYS9mcy9jaWZzL3NtYjJtaXNjLmMKKysrIGIvZnMvY2lmcy9zbWIybWlzYy5jCkBAIC02NTks
MyArNjU5LDQ5IEBAIHNtYjJfaXNfdmFsaWRfb3Bsb2NrX2JyZWFrKGNoYXIgKmJ1ZmZlciwgc3Ry
dWN0IFRDUF9TZXJ2ZXJfSW5mbyAqc2VydmVyKQogCWNpZnNfZGJnKEZZSSwgIkNhbiBub3QgcHJv
Y2VzcyBvcGxvY2sgYnJlYWsgZm9yIG5vbi1leGlzdGVudCBjb25uZWN0aW9uXG4iKTsKIAlyZXR1
cm4gZmFsc2U7CiB9CisKK3ZvaWQKK3NtYjJfY2FuY2VsbGVkX2Nsb3NlX2ZpZChzdHJ1Y3Qgd29y
a19zdHJ1Y3QgKndvcmspCit7CisJc3RydWN0IGNsb3NlX2NhbmNlbGxlZF9vcGVuICpjYW5jZWxs
ZWQgPSBjb250YWluZXJfb2Yod29yaywKKwkJCQkJc3RydWN0IGNsb3NlX2NhbmNlbGxlZF9vcGVu
LCB3b3JrKTsKKworCWNpZnNfZGJnKFZGUywgIkNsb3NlIHVubWF0Y2hlZCBvcGVuXG4iKTsKKwor
CVNNQjJfY2xvc2UoMCwgY2FuY2VsbGVkLT50Y29uLCBjYW5jZWxsZWQtPmZpZC5wZXJzaXN0ZW50
X2ZpZCwKKwkJICAgY2FuY2VsbGVkLT5maWQudm9sYXRpbGVfZmlkKTsKKwljaWZzX3B1dF90Y29u
KGNhbmNlbGxlZC0+dGNvbik7CisJa2ZyZWUoY2FuY2VsbGVkKTsKK30KKworaW50CitzbWIyX2hh
bmRsZV9jYW5jZWxsZWRfbWlkKGNoYXIgKmJ1ZmZlciwgc3RydWN0IFRDUF9TZXJ2ZXJfSW5mbyAq
c2VydmVyKQoreworCXN0cnVjdCBzbWIyX3N5bmNfaGRyICpzeW5jX2hkciA9IGdldF9zeW5jX2hk
cihidWZmZXIpOworCXN0cnVjdCBzbWIyX2NyZWF0ZV9yc3AgKnJzcCA9IChzdHJ1Y3Qgc21iMl9j
cmVhdGVfcnNwICopYnVmZmVyOworCXN0cnVjdCBjaWZzX3Rjb24gKnRjb247CisJc3RydWN0IGNs
b3NlX2NhbmNlbGxlZF9vcGVuICpjYW5jZWxsZWQ7CisKKwlpZiAoc3luY19oZHItPkNvbW1hbmQg
IT0gU01CMl9DUkVBVEUgfHwKKwkgICAgc3luY19oZHItPlN0YXR1cyAhPSBTVEFUVVNfU1VDQ0VT
UykKKwkJcmV0dXJuIDA7CisKKwljYW5jZWxsZWQgPSBremFsbG9jKHNpemVvZigqY2FuY2VsbGVk
KSwgR0ZQX0tFUk5FTCk7CisJaWYgKCFjYW5jZWxsZWQpCisJCXJldHVybiAtRU5PTUVNOworCisJ
dGNvbiA9IHNtYjJfZmluZF9zbWJfdGNvbihzZXJ2ZXIsIHN5bmNfaGRyLT5TZXNzaW9uSWQsCisJ
CQkJICBzeW5jX2hkci0+VHJlZUlkKTsKKwlpZiAoIXRjb24pIHsKKwkJa2ZyZWUoY2FuY2VsbGVk
KTsKKwkJcmV0dXJuIC1FTk9FTlQ7CisJfQorCisJY2FuY2VsbGVkLT5maWQucGVyc2lzdGVudF9m
aWQgPSByc3AtPlBlcnNpc3RlbnRGaWxlSWQ7CisJY2FuY2VsbGVkLT5maWQudm9sYXRpbGVfZmlk
ID0gcnNwLT5Wb2xhdGlsZUZpbGVJZDsKKwljYW5jZWxsZWQtPnRjb24gPSB0Y29uOworCUlOSVRf
V09SSygmY2FuY2VsbGVkLT53b3JrLCBzbWIyX2NhbmNlbGxlZF9jbG9zZV9maWQpOworCXF1ZXVl
X3dvcmsoY2lmc2lvZF93cSwgJmNhbmNlbGxlZC0+d29yayk7CisKKwlyZXR1cm4gMDsKK30KZGlm
ZiAtLWdpdCBhL2ZzL2NpZnMvc21iMm9wcy5jIGIvZnMvY2lmcy9zbWIyb3BzLmMKaW5kZXggNTgz
YTBlMi4uN2IxMmE3MiAxMDA2NDQKLS0tIGEvZnMvY2lmcy9zbWIyb3BzLmMKKysrIGIvZnMvY2lm
cy9zbWIyb3BzLmMKQEAgLTIxOTUsNyArMjE5NSw3IEBAIHJlY2VpdmVfZW5jcnlwdGVkX3JlYWQo
c3RydWN0IFRDUF9TZXJ2ZXJfSW5mbyAqc2VydmVyLCBzdHJ1Y3QgbWlkX3FfZW50cnkgKiptaWQp
CiAJaWYgKHJjKQogCQlnb3RvIGZyZWVfcGFnZXM7CiAKLQlyYyA9IGNpZnNfZGlzY2FyZF9yZW1h
aW5pbmdfZGF0YShzZXJ2ZXIpOworCXJjID0gY2lmc19kaXNjYXJkX3JlbWFpbmluZ19kYXRhKHNl
cnZlciwgYnVmKTsKIAlpZiAocmMpCiAJCWdvdG8gZnJlZV9wYWdlczsKIApAQCAtMjIyMSw3ICsy
MjIxLDcgQEAgcmVjZWl2ZV9lbmNyeXB0ZWRfcmVhZChzdHJ1Y3QgVENQX1NlcnZlcl9JbmZvICpz
ZXJ2ZXIsIHN0cnVjdCBtaWRfcV9lbnRyeSAqKm1pZCkKIAlrZnJlZShwYWdlcyk7CiAJcmV0dXJu
IHJjOwogZGlzY2FyZF9kYXRhOgotCWNpZnNfZGlzY2FyZF9yZW1haW5pbmdfZGF0YShzZXJ2ZXIp
OworCWNpZnNfZGlzY2FyZF9yZW1haW5pbmdfZGF0YShzZXJ2ZXIsIGJ1Zik7CiAJZ290byBmcmVl
X3BhZ2VzOwogfQogCkBAIC0yMzI5LDYgKzIzMjksNyBAQCBzdHJ1Y3Qgc21iX3ZlcnNpb25fb3Bl
cmF0aW9ucyBzbWIyMF9vcGVyYXRpb25zID0gewogCS5jbGVhcl9zdGF0cyA9IHNtYjJfY2xlYXJf
c3RhdHMsCiAJLnByaW50X3N0YXRzID0gc21iMl9wcmludF9zdGF0cywKIAkuaXNfb3Bsb2NrX2Jy
ZWFrID0gc21iMl9pc192YWxpZF9vcGxvY2tfYnJlYWssCisJLmhhbmRsZV9jYW5jZWxsZWRfbWlk
ID0gc21iMl9oYW5kbGVfY2FuY2VsbGVkX21pZCwKIAkuZG93bmdyYWRlX29wbG9jayA9IHNtYjJf
ZG93bmdyYWRlX29wbG9jaywKIAkubmVlZF9uZWcgPSBzbWIyX25lZWRfbmVnLAogCS5uZWdvdGlh
dGUgPSBzbWIyX25lZ290aWF0ZSwKQEAgLTI0MTEsNiArMjQxMiw3IEBAIHN0cnVjdCBzbWJfdmVy
c2lvbl9vcGVyYXRpb25zIHNtYjIxX29wZXJhdGlvbnMgPSB7CiAJLmNsZWFyX3N0YXRzID0gc21i
Ml9jbGVhcl9zdGF0cywKIAkucHJpbnRfc3RhdHMgPSBzbWIyX3ByaW50X3N0YXRzLAogCS5pc19v
cGxvY2tfYnJlYWsgPSBzbWIyX2lzX3ZhbGlkX29wbG9ja19icmVhaywKKwkuaGFuZGxlX2NhbmNl
bGxlZF9taWQgPSBzbWIyX2hhbmRsZV9jYW5jZWxsZWRfbWlkLAogCS5kb3duZ3JhZGVfb3Bsb2Nr
ID0gc21iMl9kb3duZ3JhZGVfb3Bsb2NrLAogCS5uZWVkX25lZyA9IHNtYjJfbmVlZF9uZWcsCiAJ
Lm5lZ290aWF0ZSA9IHNtYjJfbmVnb3RpYXRlLApAQCAtMjQ5NSw2ICsyNDk3LDcgQEAgc3RydWN0
IHNtYl92ZXJzaW9uX29wZXJhdGlvbnMgc21iMzBfb3BlcmF0aW9ucyA9IHsKIAkucHJpbnRfc3Rh
dHMgPSBzbWIyX3ByaW50X3N0YXRzLAogCS5kdW1wX3NoYXJlX2NhcHMgPSBzbWIyX2R1bXBfc2hh
cmVfY2FwcywKIAkuaXNfb3Bsb2NrX2JyZWFrID0gc21iMl9pc192YWxpZF9vcGxvY2tfYnJlYWss
CisJLmhhbmRsZV9jYW5jZWxsZWRfbWlkID0gc21iMl9oYW5kbGVfY2FuY2VsbGVkX21pZCwKIAku
ZG93bmdyYWRlX29wbG9jayA9IHNtYjJfZG93bmdyYWRlX29wbG9jaywKIAkubmVlZF9uZWcgPSBz
bWIyX25lZWRfbmVnLAogCS5uZWdvdGlhdGUgPSBzbWIyX25lZ290aWF0ZSwKQEAgLTI1ODksNiAr
MjU5Miw3IEBAIHN0cnVjdCBzbWJfdmVyc2lvbl9vcGVyYXRpb25zIHNtYjMxMV9vcGVyYXRpb25z
ID0gewogCS5wcmludF9zdGF0cyA9IHNtYjJfcHJpbnRfc3RhdHMsCiAJLmR1bXBfc2hhcmVfY2Fw
cyA9IHNtYjJfZHVtcF9zaGFyZV9jYXBzLAogCS5pc19vcGxvY2tfYnJlYWsgPSBzbWIyX2lzX3Zh
bGlkX29wbG9ja19icmVhaywKKwkuaGFuZGxlX2NhbmNlbGxlZF9taWQgPSBzbWIyX2hhbmRsZV9j
YW5jZWxsZWRfbWlkLAogCS5kb3duZ3JhZGVfb3Bsb2NrID0gc21iMl9kb3duZ3JhZGVfb3Bsb2Nr
LAogCS5uZWVkX25lZyA9IHNtYjJfbmVlZF9uZWcsCiAJLm5lZ290aWF0ZSA9IHNtYjJfbmVnb3Rp
YXRlLApkaWZmIC0tZ2l0IGEvZnMvY2lmcy9zbWIycHJvdG8uaCBiL2ZzL2NpZnMvc21iMnByb3Rv
LmgKaW5kZXggNjllMzU4Ny4uNjg1MzQ1NCAxMDA2NDQKLS0tIGEvZnMvY2lmcy9zbWIycHJvdG8u
aAorKysgYi9mcy9jaWZzL3NtYjJwcm90by5oCkBAIC00OCw2ICs0OCwxMCBAQCBleHRlcm4gc3Ry
dWN0IG1pZF9xX2VudHJ5ICpzbWIyX3NldHVwX3JlcXVlc3Qoc3RydWN0IGNpZnNfc2VzICpzZXMs
CiAJCQkgICAgICBzdHJ1Y3Qgc21iX3Jxc3QgKnJxc3QpOwogZXh0ZXJuIHN0cnVjdCBtaWRfcV9l
bnRyeSAqc21iMl9zZXR1cF9hc3luY19yZXF1ZXN0KAogCQkJc3RydWN0IFRDUF9TZXJ2ZXJfSW5m
byAqc2VydmVyLCBzdHJ1Y3Qgc21iX3Jxc3QgKnJxc3QpOworZXh0ZXJuIHN0cnVjdCBjaWZzX3Nl
cyAqc21iMl9maW5kX3NtYl9zZXMoc3RydWN0IFRDUF9TZXJ2ZXJfSW5mbyAqc2VydmVyLAorCQkJ
CQkgICBfX3U2NCBzZXNfaWQpOworZXh0ZXJuIHN0cnVjdCBjaWZzX3Rjb24gKnNtYjJfZmluZF9z
bWJfdGNvbihzdHJ1Y3QgVENQX1NlcnZlcl9JbmZvICpzZXJ2ZXIsCisJCQkJCQlfX3U2NCBzZXNf
aWQsIF9fdTMyICB0aWQpOwogZXh0ZXJuIGludCBzbWIyX2NhbGNfc2lnbmF0dXJlKHN0cnVjdCBz
bWJfcnFzdCAqcnFzdCwKIAkJCQlzdHJ1Y3QgVENQX1NlcnZlcl9JbmZvICpzZXJ2ZXIpOwogZXh0
ZXJuIGludCBzbWIzX2NhbGNfc2lnbmF0dXJlKHN0cnVjdCBzbWJfcnFzdCAqcnFzdCwKQEAgLTE2
NCw2ICsxNjgsOSBAQCBleHRlcm4gaW50IFNNQjJfc2V0X2NvbXByZXNzaW9uKGNvbnN0IHVuc2ln
bmVkIGludCB4aWQsIHN0cnVjdCBjaWZzX3Rjb24gKnRjb24sCiBleHRlcm4gaW50IFNNQjJfb3Bs
b2NrX2JyZWFrKGNvbnN0IHVuc2lnbmVkIGludCB4aWQsIHN0cnVjdCBjaWZzX3Rjb24gKnRjb24s
CiAJCQkgICAgIGNvbnN0IHU2NCBwZXJzaXN0ZW50X2ZpZCwgY29uc3QgdTY0IHZvbGF0aWxlX2Zp
ZCwKIAkJCSAgICAgY29uc3QgX191OCBvcGxvY2tfbGV2ZWwpOworZXh0ZXJuIGludCBzbWIyX2hh
bmRsZV9jYW5jZWxsZWRfbWlkKGNoYXIgKmJ1ZmZlciwKKwkJCQkJc3RydWN0IFRDUF9TZXJ2ZXJf
SW5mbyAqc2VydmVyKTsKK3ZvaWQgc21iMl9jYW5jZWxsZWRfY2xvc2VfZmlkKHN0cnVjdCB3b3Jr
X3N0cnVjdCAqd29yayk7CiBleHRlcm4gaW50IFNNQjJfUUZTX2luZm8oY29uc3QgdW5zaWduZWQg
aW50IHhpZCwgc3RydWN0IGNpZnNfdGNvbiAqdGNvbiwKIAkJCSB1NjQgcGVyc2lzdGVudF9maWxl
X2lkLCB1NjQgdm9sYXRpbGVfZmlsZV9pZCwKIAkJCSBzdHJ1Y3Qga3N0YXRmcyAqRlNEYXRhKTsK
ZGlmZiAtLWdpdCBhL2ZzL2NpZnMvc21iMnRyYW5zcG9ydC5jIGIvZnMvY2lmcy9zbWIydHJhbnNw
b3J0LmMKaW5kZXggN2MzYmIxYi4uNTA2YjY3ZiAxMDA2NDQKLS0tIGEvZnMvY2lmcy9zbWIydHJh
bnNwb3J0LmMKKysrIGIvZnMvY2lmcy9zbWIydHJhbnNwb3J0LmMKQEAgLTExNSwyMyArMTE1LDcw
IEBAIHNtYjNfY3J5cHRvX3NoYXNoX2FsbG9jYXRlKHN0cnVjdCBUQ1BfU2VydmVyX0luZm8gKnNl
cnZlcikKIAlyZXR1cm4gMDsKIH0KIAotc3RydWN0IGNpZnNfc2VzICoKLXNtYjJfZmluZF9zbWJf
c2VzKHN0cnVjdCBUQ1BfU2VydmVyX0luZm8gKnNlcnZlciwgX191NjQgc2VzX2lkKQorc3RhdGlj
IHN0cnVjdCBjaWZzX3NlcyAqCitzbWIyX2ZpbmRfc21iX3Nlc191bmxvY2tlZChzdHJ1Y3QgVENQ
X1NlcnZlcl9JbmZvICpzZXJ2ZXIsIF9fdTY0IHNlc19pZCkKIHsKIAlzdHJ1Y3QgY2lmc19zZXMg
KnNlczsKIAotCXNwaW5fbG9jaygmY2lmc190Y3Bfc2VzX2xvY2spOwogCWxpc3RfZm9yX2VhY2hf
ZW50cnkoc2VzLCAmc2VydmVyLT5zbWJfc2VzX2xpc3QsIHNtYl9zZXNfbGlzdCkgewogCQlpZiAo
c2VzLT5TdWlkICE9IHNlc19pZCkKIAkJCWNvbnRpbnVlOwotCQlzcGluX3VubG9jaygmY2lmc190
Y3Bfc2VzX2xvY2spOwogCQlyZXR1cm4gc2VzOwogCX0KKworCXJldHVybiBOVUxMOworfQorCitz
dHJ1Y3QgY2lmc19zZXMgKgorc21iMl9maW5kX3NtYl9zZXMoc3RydWN0IFRDUF9TZXJ2ZXJfSW5m
byAqc2VydmVyLCBfX3U2NCBzZXNfaWQpCit7CisJc3RydWN0IGNpZnNfc2VzICpzZXM7CisKKwlz
cGluX2xvY2soJmNpZnNfdGNwX3Nlc19sb2NrKTsKKwlzZXMgPSBzbWIyX2ZpbmRfc21iX3Nlc191
bmxvY2tlZChzZXJ2ZXIsIHNlc19pZCk7CiAJc3Bpbl91bmxvY2soJmNpZnNfdGNwX3Nlc19sb2Nr
KTsKIAorCXJldHVybiBzZXM7Cit9CisKK3N0YXRpYyBzdHJ1Y3QgY2lmc190Y29uICoKK3NtYjJf
ZmluZF9zbWJfc2Vzc190Y29uX3VubG9ja2VkKHN0cnVjdCBjaWZzX3NlcyAqc2VzLCBfX3UzMiAg
dGlkKQoreworCXN0cnVjdCBjaWZzX3Rjb24gKnRjb247CisKKwlsaXN0X2Zvcl9lYWNoX2VudHJ5
KHRjb24sICZzZXMtPnRjb25fbGlzdCwgdGNvbl9saXN0KSB7CisJCWlmICh0Y29uLT50aWQgIT0g
dGlkKQorCQkJY29udGludWU7CisJCSsrdGNvbi0+dGNfY291bnQ7CisJCXJldHVybiB0Y29uOwor
CX0KKwogCXJldHVybiBOVUxMOwogfQogCisvKgorICogT2J0YWluIHRjb24gY29ycmVzcG9uZGlu
ZyB0byB0aGUgdGlkIGluIHRoZSBnaXZlbgorICogY2lmc19zZXMKKyAqLworCitzdHJ1Y3QgY2lm
c190Y29uICoKK3NtYjJfZmluZF9zbWJfdGNvbihzdHJ1Y3QgVENQX1NlcnZlcl9JbmZvICpzZXJ2
ZXIsIF9fdTY0IHNlc19pZCwgX191MzIgIHRpZCkKK3sKKwlzdHJ1Y3QgY2lmc19zZXMgKnNlczsK
KwlzdHJ1Y3QgY2lmc190Y29uICp0Y29uOworCisJc3Bpbl9sb2NrKCZjaWZzX3RjcF9zZXNfbG9j
ayk7CisJc2VzID0gc21iMl9maW5kX3NtYl9zZXNfdW5sb2NrZWQoc2VydmVyLCBzZXNfaWQpOwor
CWlmICghc2VzKSB7CisJCXNwaW5fdW5sb2NrKCZjaWZzX3RjcF9zZXNfbG9jayk7CisJCXJldHVy
biBOVUxMOworCX0KKwl0Y29uID0gc21iMl9maW5kX3NtYl9zZXNzX3Rjb25fdW5sb2NrZWQoc2Vz
LCB0aWQpOworCXNwaW5fdW5sb2NrKCZjaWZzX3RjcF9zZXNfbG9jayk7CisKKwlyZXR1cm4gdGNv
bjsKK30KKwogaW50CiBzbWIyX2NhbGNfc2lnbmF0dXJlKHN0cnVjdCBzbWJfcnFzdCAqcnFzdCwg
c3RydWN0IFRDUF9TZXJ2ZXJfSW5mbyAqc2VydmVyKQogewpkaWZmIC0tZ2l0IGEvZnMvY2lmcy90
cmFuc3BvcnQuYyBiL2ZzL2NpZnMvdHJhbnNwb3J0LmMKaW5kZXggNTI2ZjA1My4uZjZlMTNhOSAx
MDA2NDQKLS0tIGEvZnMvY2lmcy90cmFuc3BvcnQuYworKysgYi9mcy9jaWZzL3RyYW5zcG9ydC5j
CkBAIC03NTIsOSArNzUyLDExIEBAIGNpZnNfc2VuZF9yZWN2KGNvbnN0IHVuc2lnbmVkIGludCB4
aWQsIHN0cnVjdCBjaWZzX3NlcyAqc2VzLAogCiAJcmMgPSB3YWl0X2Zvcl9yZXNwb25zZShzZXMt
PnNlcnZlciwgbWlkUSk7CiAJaWYgKHJjICE9IDApIHsKKwkJY2lmc19kYmcoRllJLCAiQ2FuY2Vs
bGluZyB3YWl0IGZvciBtaWQgJWxsdVxuIiwJbWlkUS0+bWlkKTsKIAkJc2VuZF9jYW5jZWwoc2Vz
LT5zZXJ2ZXIsIHJxc3QsIG1pZFEpOwogCQlzcGluX2xvY2soJkdsb2JhbE1pZF9Mb2NrKTsKIAkJ
aWYgKG1pZFEtPm1pZF9zdGF0ZSA9PSBNSURfUkVRVUVTVF9TVUJNSVRURUQpIHsKKwkJCW1pZFEt
Pm1pZF9mbGFncyB8PSBNSURfV0FJVF9DQU5DRUxMRUQ7CiAJCQltaWRRLT5jYWxsYmFjayA9IERl
bGV0ZU1pZFFFbnRyeTsKIAkJCXNwaW5fdW5sb2NrKCZHbG9iYWxNaWRfTG9jayk7CiAJCQlhZGRf
Y3JlZGl0cyhzZXMtPnNlcnZlciwgMSwgb3B0eXBlKTsKLS0gCjIuOS4zCgo=


--=-7hdEan0OBBLfqlB/CPMC--
