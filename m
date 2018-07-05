From: Stefano Brivio <sbrivio@redhat.com>
Subject: Re: [PATCH] cifs: Fix slab-out-of-bounds in send_set_info() on SMB2
 ACE setting
Date: Thu, 5 Jul 2018 16:58:58 +0200
Message-ID: <20180705165858.7679fc44@epycfail>
References: <af471807b329692a387ff26e62e1bbca01e1684f.1530783326.git.sbrivio@redhat.com>
        <87d0w17nu3.fsf@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Cc: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Jianhong Yin <jiyin@redhat.com>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Shirish Pargaonkar <shirishpargaonkar@gmail.com>,
        stable@vger.kernel.org
To: =?UTF-8?B?QXVyw6lsaWVu?= Aptel <aaptel@suse.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <87d0w17nu3.fsf@suse.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Thu, 05 Jul 2018 16:35:00 +0200
Aurélien Aptel <aaptel@suse.com> wrote:

> Stefano Brivio <sbrivio@redhat.com> writes:
> >  	/* BB eventually switch this to SMB2 specific small buf size */
> > -	*request_buf = cifs_small_buf_get();
> > +	if (smb2_command == SMB2_SET_INFO)
> > +		*request_buf = cifs_buf_get();
> > +	else
> > +		*request_buf = cifs_small_buf_get();
> >  	if (*request_buf == NULL) {
> >  		/* BB should we add a retry in here if not a writepage? */
> >  		return -ENOMEM;
> > @@ -3720,7 +3723,7 @@ send_set_info(const unsigned int xid, struct cifs_tcon *tcon,
> >  
> >  	rc = cifs_send_recv(xid, ses, &rqst, &resp_buftype, flags,
> >  			    &rsp_iov);
> > -	cifs_small_buf_release(req);
> > +	cifs_buf_release(req);
> >  	rsp = (struct smb2_set_info_rsp *)rsp_iov.iov_base;  
> 
> Small and large bufs use different mempools, shouldn't the release func
> match the get func?

I think it does: for SMB2_SET_INFO we'll allocate with cifs_buf_get(),
which does:

	ret_buf = mempool_alloc(cifs_req_poolp, GFP_NOFS);

and release with cifs_buf_release():

	mempool_free(buf_to_free, cifs_req_poolp);

am I missing something?

-- 
Stefano
