# Recipe Manager - End-to-End Test Plan

## Test Environment

- Browser: Chrome, Firefox, Safari
- Devices: Desktop, Mobile (iOS/Android)
- Test Data: Sample recipe files (image) 3-5 

---

## 1. User Authentication Tests

### Sign Up

- [x ] Sign up with valid email/password → Success
- [ x] Sign up with invalid email format → Error shown
- [ x] Sign up with password < 6 chars → Error shown
- [ x] Sign up with mismatched password confirmation → Error shown
- [ x] Select preferred units (metric/imperial) → Saved correctly
- [ x] Redirect to recipes index after signup

### Sign In

- [x ] Sign in with correct credentials → Success
- [ x] Sign in with wrong password → Error shown
- [x ] Sign in with non-existent email → Error shown
- [ x] "Remember me" checkbox works
- [ x] Redirect to recipes index after login

### Sign Out

- [ x] Sign out successfully
- [ x] Redirect to landing page
- [ x] Cannot access protected routes after signout

### Password Reset

- [ x] Request password reset → Email sent
- [ x] Click reset link → Can set new password
- [x ] Login with new password works

---

## 2. Landing Page Tests

- [ x] Non-logged-in users see landing page at `/`
- [ x] Logged-in users redirect from `/` to `/recipes`
- [x ] All CTA buttons link correctly
- [ x] Navigation works (Sign Up, Sign In)
- [ x] Responsive on mobile/tablet/desktop
- [ x] Features section displays correctly

---

## 3. Recipe Upload & AI Parsing Tests

### File Upload

- [x ] Upload .jpg image → Accepted
- [ x] Upload .png image → Accepted
- [ x] Upload file > 10MB → Rejected with error
- [x ] Upload corrupted file → Error handled gracefully

### AI Parsing

- [ x] Image recipe parsed → Correct title extracted
- [x ] Image recipe parsed → Ingredients extracted with amounts/units
- [ x] Image recipe parsed → Steps extracted in order
- [ ] Complex recipe (20+ ingredients) → Parsed correctly (stretch goal)
- [ ] Recipe with special characters → Handled correctly (stretch goal)

### Upload Flow

- [x ] File uploads to AWS S3 → URL returned
- [ x] Loading state shown during parsing
- [ x] Parsed data displayed for review
- [ x] User can edit title before saving
- [x ] User can edit ingredients before saving
- [ x] User can edit steps before saving
- [ x] User can add missing ingredients
- [x ] User can add missing steps
- [ x] Recipe saves with all data to database
- [ x] Redirect to recipe show page after save
- [x ] User can reparse recipe if easier than edting, optional (stretch goal)

---

## 4. Recipe Management Tests

### Index Page

- [ x] All user's recipes displayed
- [ x] Recipe cards show title, ingredient count, date
- [x ] Pagination works (if 12+ recipes)
- [x ] Search by recipe name works
- [x ] "Upload New Recipe" button visible

### Show Page

- [ x] Recipe title displayed
- [ x] All ingredients listed correctly
- [x ] All steps listed in order (1, 2, 3...)
- [ x] "View Original File" link works
- [ x] Edit and Delete buttons visible
- [ x] Breadcrumbs navigation works

### Edit Recipe

- [ x] Can edit recipe title
- [ x] Can add new ingredient
- [x ] Can edit existing ingredient
- [ x] Can delete ingredient
- [ x] Can add new step
- [ x] Can edit existing step
- [ x] Can delete step
- [ x] Changes save correctly
- [ x] Cannot change original uploaded file

### Delete Recipe

- [x ] Delete button shows confirmation
- [ x] Confirm delete → Recipe removed
- [ x] Cancel delete → Recipe remains

---

## 5. Search & Filtering Tests

- [x ] Search by recipe name (exact match)
- [x ] Search by recipe name (partial match)
- [x ] Search returns correct results
- [ x] No results message when search fails
- [x ] Clear search works

---

## 6. User Profile Tests

- [x ] Profile page shows user email
- [ x] Can edit preferred units
- [x ] Changes save successfully
- [x ] Preferred units reflected in new recipe parsing

---

## 7. Authorization Tests

- [x ] User can only see their own recipes and those they invited
- [x ] Unauthorized access redirects to login
- [x ] Logged-out users redirected to landing page

---

## 8. Email Notification Tests

- [x ] Confirmation email sent on recipe upload
- [x ] Email contains recipe title
- [x ] Email has link to recipe (link is stable, users can send link to external)
- [ x] Email formatted correctly

---

## 9. Performance Tests

- [x ] Recipe index loads in < 2 seconds
- [ x] Recipe show loads in < 1 second
- [x ] File upload completes in < 10 seconds
- [ x] AI parsing completes in < 30 seconds

---

## 10. Responsive Design Tests

### Mobile (375px width)

- [x ] Landing page renders correctly
- [ x] Navigation menu works
- [ x] Recipe cards
- [ x] Forms are usable
- [x ] File upload works
- [x ] All buttons tappable


### Desktop (1200px+ width)

- [ x] Full layout displays
- [ x] Navigation inline
- [ x] Recipe grid (3 columns)

---

## 11. Browser Compatibility Tests

- [x ] Chrome (latest)
- [x ] Safari (latest)
- [x ] Mobile Safari (iOS)

---

## 12. Edge Cases

- [ ] Very long step (1000+ characters)
- [ ] Simultaneous uploads from same user
- [ x] Poor network connection (slow upload)
- [ x] Session timeout during upload
- [x ] Duplicate recipe titles

---

## Test Summary

**Total Tests:** 103+
**Passed:** **_ 92 _**
**Failed:** **_ 11 _**
**Blocked:** **_ 3 _**

**Tested By:** [BRW]
**Date:** [2/24/26]
**Environment:** [Production/Staging/Development]
```

![R.Spec Test 1- Success 2/14/26 ](image-1.png)
