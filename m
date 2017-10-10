From: Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: Re: [PATCH 16/16] cifs: Use find_get_pages_range_tag()
Date: Tue, 10 Oct 2017 13:48:24 -0400
Message-ID: <ce33f739-7378-4b0f-206d-6f3380da5adf@oracle.com>
References: <20171009151359.31984-1-jack@suse.cz>
 <20171009151359.31984-17-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-cifs@vger.kernel.org,
        Steve French <sfrench@samba.org>
To: Jan Kara <jack@suse.cz>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20171009151359.31984-17-jack@suse.cz>
Content-Language: en-US
Sender: owner-linux-mm@kvack.org
List-Id: linux-cifs.vger.kernel.org

Hi Jan,

On 10/09/2017 11:13 AM, Jan Kara wrote:
> wdata_alloc_and_fillpages() needlessly iterates calls to
> find_get_pages_tag(). Also it wants only pages from given range. Make it
> use find_get_pages_range_tag().

Looks good, so

Reviewed-by: Daniel Jordan <daniel.m.jordan@oracle.com>

The rest of the v3 updates seem fine, too.

Daniel

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
