From: Steve French <smfrench@gmail.com>
Subject: Re: [PATCH] cifs: fix memory leak of an allocated cifs_ntsd structure
Date: Tue, 8 Jan 2019 11:46:00 -0600
Message-ID: <CAH2r5mtR_uoe8ovH=+RBSbS0oRFO7OS-kGwG6n6RBvQfgXaKGw@mail.gmail.com>
References: <20190107171515.4537-1-colin.king@canonical.com>
 <20190108094249.GF3200@kadam> <2f01add7-06f0-e312-2018-18b056405d6a@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        kernel-janitors <kernel-janitors@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
To: Colin Ian King <colin.king@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <2f01add7-06f0-e312-2018-18b056405d6a@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Yes - good point.  Will back this out temporarily, and also update
Aurelien's (unrelated patch) to the later version

On Tue, Jan 8, 2019 at 3:52 AM Colin Ian King <colin.king@canonical.com> wrote:
>
> On 08/01/2019 09:42, Dan Carpenter wrote:
> > On Mon, Jan 07, 2019 at 05:15:15PM +0000, Colin King wrote:
> >> From: Colin Ian King <colin.king@canonical.com>
> >>
> >> The call to SMB2_queary_acl can allocate memory to pntsd and also
> >> return a failure via a call to SMB2_query_acl (and then query_info).
> >> This occurs when query_info allocates the structure and then in
> >> query_info the call to smb2_validate_and_copy_iov fails. Currently the
> >> failure just returns without kfree'ing pntsd hence causing a memory
> >> leak.  Fix this by kfree'ing pntsd before returning.
> >>
> >> Detected by CoverityScan, CID#1457059 ("Resource Leak")
> >>
> >> Fixes: 2f1afe25997f ("cifs: Use smb 2 - 3 and cifsacl mount options getacl functions")
> >> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> >> ---
> >>  fs/cifs/smb2ops.c | 4 +++-
> >>  1 file changed, 3 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> >> index cf7eb891804f..6d71958ad2cb 100644
> >> --- a/fs/cifs/smb2ops.c
> >> +++ b/fs/cifs/smb2ops.c
> >> @@ -2238,8 +2238,10 @@ get_smb2_acl_by_fid(struct cifs_sb_info *cifs_sb,
> >>      cifs_put_tlink(tlink);
> >>
> >>      cifs_dbg(FYI, "%s: rc = %d ACL len %d\n", __func__, rc, *pacllen);
> >> -    if (rc)
> >> +    if (rc) {
> >> +            kfree(pntsd);
> >>              return ERR_PTR(rc);
> >> +    }
> >
> > This is a layering violation.  The memory was allocated in query_info()
> > so it should be freed there instead.  Also if the kmalloc() fails in
> > query_info() then it should return -ENOMEM instead of success.
> >
> > This only affects code which calls SMB2_query_acl().  There are two
> > callers.  You have fixed one but the other is also buggy because we're
> > returning uninitialized memory in get_smb2_acl_by_path().
> >
> > regards,
> > dan carpenter
> >
>
> Eep. very true. NACK to my fixes and I'll sort out a correct fix later.
>
> Colin



-- 
Thanks,

Steve
