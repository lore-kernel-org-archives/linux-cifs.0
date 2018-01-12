From: aaptel-IBi9RG/b67k@public.gmane.org (=?utf-8?Q?Aur=C3=A9lien?= Aptel)
Subject: tcon and session refcounts, get/put
Date: Fri, 12 Jan 2018 19:38:47 +0100
Message-ID: <876086apmw.fsf@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jeff Layton <jlayton-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi,

While working on a bug I've found something strange.

cifs_get_tcon(ses, volinfo) looks for a tcon matching volinfo in ses
tcon list. If it doesn't find one it create one.

Can someone explain to me why when it finds a matching one, it *puts*
the session?

static struct cifs_tcon *
cifs_get_tcon(struct cifs_ses *ses, struct smb_vol *volume_info)
{
	int rc, xid;
	struct cifs_tcon *tcon;

	tcon = cifs_find_tcon(ses, volume_info);
	if (tcon) {
		cifs_dbg(FYI, "Found match on UNC path\n");
		/* existing tcon already has a reference */
		cifs_put_smb_ses(ses); <---- why?
		return tcon;
	}

        <... code that creates the missing tcon ...>

I think the "existing tcon already has a reference" comment refers to the
fact that cifs_find_tcon() already increments the refcount of the tcon
and so there's no need to do it a second time.

static struct cifs_tcon *
cifs_find_tcon(struct cifs_ses *ses, struct smb_vol *volume_info)
{
	struct list_head *tmp;
	struct cifs_tcon *tcon;

	spin_lock(&cifs_tcp_ses_lock);
	list_for_each(tmp, &ses->tcon_list) {
		tcon = list_entry(tmp, struct cifs_tcon, tcon_list);
		if (!match_tcon(tcon, volume_info))
			continue;
		++tcon->tc_count;
		spin_unlock(&cifs_tcp_ses_lock);
		return tcon;
	}
	spin_unlock(&cifs_tcp_ses_lock);
	return NULL;
}


I don't understand the logic here and I have a feeling it might be a
bug.

-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Linux GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
