From: Chris Mason <clmason@fusionio.com>
Subject: Re: [RFC v0 1/4] vfs: add copy_range syscall and vfs entry point
Date: Wed, 15 May 2013 16:25:43 -0400
Message-ID: <20130515202543.24668.14371@localhost.localdomain>
References: <CAH2r5ms0P8Hgv1mUpyHA32Er38iiaC1HHC4fhxvz2SBFy6Sucw@mail.gmail.com>
 <20130515193600.GA318@lenny.home.zabbo.net>
 <CAH2r5mtA54fM-M1X7MS0FNeuXFh91UoarJ5QiKTk=vdSXHWFHg@mail.gmail.com>
 <20130515201614.24668.83788@localhost.localdomain>
 <CAH2r5mvM4_FjfvNcjdxeU73oZ7uO4r0CYKJ6MXORjERMFr=26w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Cc: Zach Brown <zab@redhat.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	"linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
	"J. Bruce Fields" <bfields@fieldses.org>
To: Steve French <smfrench@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CAH2r5mvM4_FjfvNcjdxeU73oZ7uO4r0CYKJ6MXORjERMFr=26w@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Quoting Steve French (2013-05-15 16:21:12)
> On Wed, May 15, 2013 at 3:16 PM, Chris Mason <chris.mason@fusionio.com> wrote:
> > truncate_inode_pages_range ends with invalidate.  It just locks the page
> > first and makes sure to wait for writeback if it was already in
> > progress.
> 
> Does
> 
>      truncate_inode_pages_range(&inode->i_data, destoff,
>                             PAGE_CACHE_ALIGN(destoff + len) - 1);
> 
> 
> I also am worried about what does:
> 
> 1) writing out data from start of previous page up to destoff (if
> destoff not page aligned, and first page dirty)
> 2) writing out data from dest+len through end of page (if destoff not
> page aligned, and last page dirty)
> 
> before tossing first through last page out

It does a check for a partial first page (sending down the partial
offset to invalidatepage), but the last page is fully truncated.

-chris

